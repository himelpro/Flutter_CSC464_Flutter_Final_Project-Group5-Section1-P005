import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/student_provider.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  const AttendanceHistoryScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<AttendanceProvider>();
    final studentProvider = context.read<StudentProvider>();

    final courseRecords = attendanceProvider.records
        .where((r) => r.courseId == courseId)
        .toList();
    final totalEnrolled = studentProvider.getStudentsByCourse(courseId).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2851)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attendance History',
          style: TextStyle(
            color: Color(0xFF0F2851),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F2851),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 24),
            if (courseRecords.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'No attendance records found.',
                    style: TextStyle(color: Color(0xFF4A5A7B)),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: courseRecords.length,
                  itemBuilder: (context, index) {
                    final record = courseRecords[index];
                    final presentCount = record.studentAttendance.values
                        .where((v) => v == true)
                        .length;

                    return Card(
                      color: const Color(0xFFF3F4F6),
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              record.date,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F2851),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9E2F2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$presentCount/$totalEnrolled',
                                style: const TextStyle(
                                  color: Color(0xFF4A5A7B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
