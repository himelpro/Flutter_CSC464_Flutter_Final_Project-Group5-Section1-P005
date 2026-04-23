import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../providers/student_provider.dart';
import '../providers/course_provider.dart';

class AddStudentSheet extends StatefulWidget {
  const AddStudentSheet({super.key});
  @override
  State<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<AddStudentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final List<String> _selectedCourseIds = [];

  @override
  Widget build(BuildContext context) {
    final availableCourses = context.read<CourseProvider>().courses;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 32,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Student',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F2851),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'STUDENT NAME',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0F2851),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Student name required'
                    : null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'STUDENT ID',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0F2851),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _idController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Student ID required'
                    : null,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'EMAIL ADDRESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0F2851),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email required';
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'COURSE ENROLLMENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0F2851),
                ),
              ),
              const SizedBox(height: 8),
              if (availableCourses.isEmpty)
                const Text(
                  'No courses available.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableCourses.map((course) {
                    final isSelected = _selectedCourseIds.contains(course.id);
                    return FilterChip(
                      label: Text(course.name),
                      selected: isSelected,
                      selectedColor: const Color(0xFFD9E2F2),
                      backgroundColor: const Color(0xFFF3F4F6),
                      checkmarkColor: const Color(0xFF0F2851),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? const Color(0xFF0F2851)
                            : const Color(0xFF4A5A7B),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedCourseIds.add(course.id);
                          } else {
                            _selectedCourseIds.remove(course.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5A7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newStudent = Student(
                        id: _idController.text,
                        name: _nameController.text,
                        email: _emailController.text,
                        enrolledCourseIds: List.from(_selectedCourseIds),
                      );
                      context.read<StudentProvider>().addStudent(newStudent);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF0F2851),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
