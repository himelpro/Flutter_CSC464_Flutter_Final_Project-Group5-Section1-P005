import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/student_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();
    final studentProvider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'Faculty Overview',
          style: TextStyle(
            color: Color(0xFF4A5A7B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0F2851),
              radius: 18,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dr. Aris\nThorne',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F2851),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Senior Faculty\nDept. of Computer Science',
              style: TextStyle(fontSize: 16, color: Color(0xFF4A5A7B)),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: courseProvider.courses.isEmpty
                  ? const Center(
                      child: Text(
                        'No active courses found. Go to the Course tab to add one.',
                        style: TextStyle(color: Color(0xFF4A5A7B)),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: courseProvider.courses.length,
                      itemBuilder: (context, index) {
                        final course = courseProvider.courses[index];

                        // --- Logic: Calculate Classes Held ---
                        final courseRecords = attendanceProvider.records
                            .where((r) => r.courseId == course.id)
                            .toList();
                        final classesHeld = courseRecords.length;

                        // --- Logic: Calculate Attendance Percentage ---
                        final totalEnrolled = studentProvider
                            .getStudentsByCourse(course.id)
                            .length;
                        double attendancePercentage = 0.0;

                        if (classesHeld > 0 && totalEnrolled > 0) {
                          double totalDailyPercentages = 0.0;
                          for (var record in courseRecords) {
                            int presentCount = record.studentAttendance.values
                                .where((v) => v == true)
                                .length;
                            totalDailyPercentages +=
                                (presentCount / totalEnrolled);
                          }
                          attendancePercentage =
                              (totalDailyPercentages / classesHeld) * 100;
                        }

                        return Card(
                          color: const Color(0xFFF3F4F6),
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9E2F2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'CSE ${course.id.length > 3 ? course.id.substring(0, 3) : course.id}', // Mocking course code format
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A5A7B),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  course.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F2851),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Classes Held',
                                      style: TextStyle(
                                        color: Color(0xFF4A5A7B),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '$classesHeld',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0F2851),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xFFE2E8F0),
                                  height: 32,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Attendance',
                                      style: TextStyle(
                                        color: Color(0xFF4A5A7B),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      classesHeld == 0 || totalEnrolled == 0
                                          ? 'N/A'
                                          : '${attendancePercentage.toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0F2851),
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
          ],
        ),
      ),
    );
  }
}
