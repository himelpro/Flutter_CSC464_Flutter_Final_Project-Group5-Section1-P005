import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/attendance_model.dart';
import '../../providers/course_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/attendance_provider.dart';
import 'attendance_history_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _selectedCourseId;
  String _selectedDate =
      "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
  Map<String, bool> _tempAttendance = {};

  void _loadExistingRecord() {
    if (_selectedCourseId == null) return;
    final existingRecord = context.read<AttendanceProvider>().getRecord(
      _selectedDate,
      _selectedCourseId!,
    );
    if (existingRecord != null) {
      setState(() {
        _tempAttendance = Map.from(existingRecord.studentAttendance);
      });
    } else {
      setState(() {
        _tempAttendance.clear();
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F2851),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F2851),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = "${picked.month}/${picked.day}/${picked.year}";
      });
      _loadExistingRecord();
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final studentProvider = context.watch<StudentProvider>();
    final students = _selectedCourseId != null
        ? studentProvider.getStudentsByCourse(_selectedCourseId!)
        : [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mark Attendance',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F2851),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              if (courseProvider.courses.isNotEmpty)
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text(
                      'Select Course',
                      style: TextStyle(color: Color(0xFF4A5568)),
                    ),
                    value: _selectedCourseId,
                    items: courseProvider.courses.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A5A7B),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCourseId = val;
                      });
                      _loadExistingRecord();
                    },
                  ),
                )
              else
                const Text(
                  'No courses available. Add courses first.',
                  style: TextStyle(fontSize: 14, color: Colors.redAccent),
                ),
            ],
          ),
        ),
      ),
      body: _selectedCourseId == null
          ? const Center(
              child: Text(
                'Please select a course above.',
                style: TextStyle(color: Color(0xFF4A5A7B)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RECORD DATE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color(0xFF0F2851),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final courseName = courseProvider.courses
                              .firstWhere((c) => c.id == _selectedCourseId)
                              .name;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceHistoryScreen(
                                courseId: _selectedCourseId!,
                                courseName: courseName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.history,
                          size: 16,
                          color: Color(0xFF4A5A7B),
                        ),
                        label: const Text(
                          'VIEW HISTORY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A5A7B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _pickDate(context),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F2851),
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Color(0xFF4A5A7B),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (students.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          'No students enrolled in this course.',
                          style: TextStyle(color: Color(0xFF4A5A7B)),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final isPresent = _tempAttendance[student.id];

                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color(
                                          0xFFD9E2F2,
                                        ),
                                        child: Text(
                                          student.name
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFF0F2851),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F2851),
                                              ),
                                            ),
                                            Text(
                                              'ID: ${student.id}',
                                              style: const TextStyle(
                                                color: Color(0xFF4A5A7B),
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => setState(
                                            () => _tempAttendance[student.id] =
                                                true,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isPresent == true
                                                  ? const Color(0xFF4A5A7B)
                                                  : const Color(0xFFF3F4F6),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft: Radius.circular(
                                                      4,
                                                    ),
                                                  ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Present',
                                              style: TextStyle(
                                                color: isPresent == true
                                                    ? Colors.white
                                                    : const Color(0xFF0F2851),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => setState(
                                            () => _tempAttendance[student.id] =
                                                false,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isPresent == false
                                                  ? const Color(0xFFFA8072)
                                                  : const Color(0xFFF3F4F6),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      4,
                                                    ),
                                                    bottomRight:
                                                        Radius.circular(4),
                                                  ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Absent',
                                              style: TextStyle(
                                                color: isPresent == false
                                                    ? Colors.white
                                                    : const Color(0xFF0F2851),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (students.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_tempAttendance.keys.length}/${students.length} Students Marked',
                            style: const TextStyle(color: Color(0xFF4A5A7B)),
                          ),
                        ],
                      ),
                    ),
                  if (students.isNotEmpty)
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
                          if (_tempAttendance.length != students.length) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please mark all students before saving.',
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }
                          final newRecord = AttendanceRecord(
                            date: _selectedDate,
                            courseId: _selectedCourseId!,
                            studentAttendance: Map.from(_tempAttendance),
                          );
                          context.read<AttendanceProvider>().saveAttendance(
                            newRecord,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Attendance Saved Successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text(
                          'Save Attendance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
