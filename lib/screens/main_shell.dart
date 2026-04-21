import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'courses/course_screen.dart';
import 'students/student_screen.dart';
import 'attendance/attendance_screen.dart';
import 'routine/routine_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0; // Defaulting to 0 so the app opens on the Dashboard

  final List<Widget> _screens = const [
    DashboardScreen(),
    CourseScreen(),
    StudentScreen(),
    AttendanceScreen(),
    RoutineScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0F2851),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'COURSE'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'STUDENT'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'ATTENDANCE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'SCHEDULE',
          ),
        ],
      ),
    );
  }
}
