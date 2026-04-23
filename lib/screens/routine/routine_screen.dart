import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/routine_provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/add_event_sheet.dart';

class TimelineItem {
  final String id;
  final String title;
  final String subtitle;
  final String startTime;
  final String endTime;
  final String room;
  final bool isCourse;
  TimelineItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.isCourse,
  });
}

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});
  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  DateTime _selectedDate = DateTime.now();

  String _getWeekdayStr(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  int _timeToMinutes(String timeString) {
    try {
      final parts = timeString.split(' ');
      final timeParts = parts[0].split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      if (parts[1] == 'PM' && hours != 12) hours += 12;
      if (parts[1] == 'AM' && hours == 12) hours = 0;
      return hours * 60 + minutes;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final routineProvider = context.watch<RoutineProvider>();
    final weekdayStr = _getWeekdayStr(_selectedDate.weekday);
    final dateStr =
        "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}";

    final todaysCourses = courseProvider.courses
        .where((c) => c.days.contains(weekdayStr))
        .toList();
    final todaysEvents = routineProvider.routines
        .where((r) => r.date == dateStr)
        .toList();

    List<TimelineItem> mergedAgenda = [];
    for (var c in todaysCourses) {
      mergedAgenda.add(
        TimelineItem(
          id: c.id,
          title: c.name,
          subtitle: 'Academic Course',
          startTime: c.startTime,
          endTime: c.endTime,
          room: c.room,
          isCourse: true,
        ),
      );
    }
    for (var e in todaysEvents) {
      mergedAgenda.add(
        TimelineItem(
          id: e.id,
          title: e.title,
          subtitle: 'Custom ${e.type}',
          startTime: e.startTime,
          endTime: e.endTime,
          room: e.room,
          isCourse: false,
        ),
      );
    }
    mergedAgenda.sort(
      (a, b) =>
          _timeToMinutes(a.startTime).compareTo(_timeToMinutes(b.startTime)),
    );

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
                'Daily\nAgenda',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F2851),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF4A5A7B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$weekdayStr, $dateStr (Tap to change)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A5A7B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: mergedAgenda.isEmpty
          ? const Center(
              child: Text(
                'No classes or events scheduled for this date.',
                style: TextStyle(color: Color(0xFF4A5A7B)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              itemCount: mergedAgenda.length,
              itemBuilder: (context, index) {
                final item = mergedAgenda[index];
                return Card(
                  color: item.isCourse
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFE6F0FA),
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: item.isCourse
                          ? Colors.transparent
                          : const Color(0xFFB8D4F0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.startTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F2851),
                              ),
                            ),
                            if (!item.isCourse)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    routineProvider.deleteRoutine(item.id),
                              ),
                          ],
                        ),
                        Text(
                          item.endTime,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4A5A7B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.isCourse
                                ? const Color(0xFFD9E2F2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A5A7B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F2851),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFF4A5A7B),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.room,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4A5A7B),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: FloatingActionButton.extended(
          heroTag: 'routineFab',
          backgroundColor: const Color(0xFF4A5A7B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              builder: (context) => AddEventSheet(preselectedDate: dateStr),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Custom Event',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
