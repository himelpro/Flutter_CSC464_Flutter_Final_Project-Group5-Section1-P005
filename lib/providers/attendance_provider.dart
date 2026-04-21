import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  List<AttendanceRecord> _records = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<AttendanceRecord> get records => _records;

  AttendanceProvider() {
    _listenToAttendance();
  }

  void _listenToAttendance() {
    _db.collection('attendance').snapshots().listen((snapshot) {
      _records = snapshot.docs
          .map((doc) => AttendanceRecord.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> saveAttendance(AttendanceRecord record) async {
    // Check if attendance was already taken for this specific course on this specific date
    var snapshot = await _db
        .collection('attendance')
        .where('date', isEqualTo: record.date)
        .where('courseId', isEqualTo: record.courseId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Overwrite the existing record
      await _db
          .collection('attendance')
          .doc(snapshot.docs.first.id)
          .update(record.toMap());
    } else {
      // Create a brand new record
      await _db.collection('attendance').add(record.toMap());
    }
  }

  AttendanceRecord? getRecord(String date, String courseId) {
    try {
      return _records.firstWhere(
        (r) => r.date == date && r.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }
}
