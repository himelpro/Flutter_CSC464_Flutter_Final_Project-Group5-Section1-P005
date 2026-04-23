import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Student> get students => _students;

  StudentProvider() {
    _listenToStudents();
  }

  List<Student> getStudentsByCourse(String courseId) =>
      _students.where((s) => s.enrolledCourseIds.contains(courseId)).toList();

  void _listenToStudents() {
    _db.collection('students').snapshots().listen((snapshot) {
      _students = snapshot.docs
          .map((doc) => Student.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addStudent(Student student) async {
    await _db.collection('students').add(student.toMap());
  }

  Future<void> updateStudent(
    String originalUniversityId,
    Student updatedStudent,
  ) async {
    // 1. Find the exact document in Firebase that matches this University ID
    var snapshot = await _db
        .collection('students')
        .where('universityId', isEqualTo: originalUniversityId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      // 2. Update it using the hidden docId
      await _db
          .collection('students')
          .doc(snapshot.docs.first.id)
          .update(updatedStudent.toMap());
    }
  }

  Future<void> deleteStudent(String universityId) async {
    var snapshot = await _db
        .collection('students')
        .where('universityId', isEqualTo: universityId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      await _db.collection('students').doc(snapshot.docs.first.id).delete();
    }
  }
}
