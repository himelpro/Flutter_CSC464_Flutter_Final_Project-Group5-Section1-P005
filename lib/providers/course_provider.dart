import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Course> get courses => _courses;

  // When the provider starts, immediately begin listening to the cloud
  CourseProvider() {
    _listenToCourses();
  }

  // The Real-Time Stream
  void _listenToCourses() {
    _db.collection('courses').snapshots().listen((snapshot) {
      // Convert the cloud data into our Flutter Course objects
      _courses = snapshot.docs
          .map((doc) => Course.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners(); // Update the UI instantly
    });
  }

  // Create
  Future<void> addCourse(Course course) async {
    await _db.collection('courses').add(course.toMap());
    // Note: We don't need to manually update the local list or call notifyListeners()
    // because the _listenToCourses() stream will detect the change automatically!
  }

  // Update
  Future<void> updateCourse(Course updatedCourse) async {
    await _db
        .collection('courses')
        .doc(updatedCourse.id)
        .update(updatedCourse.toMap());
  }

  // Delete
  Future<void> deleteCourse(String id) async {
    await _db.collection('courses').doc(id).delete();
  }
}
