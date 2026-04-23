import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/routine_model.dart';

class RoutineProvider extends ChangeNotifier {
  List<Routine> _routines = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Routine> get routines => _routines;

  RoutineProvider() {
    _listenToRoutines();
  }

  void _listenToRoutines() {
    _db.collection('routines').snapshots().listen((snapshot) {
      _routines = snapshot.docs
          .map((doc) => Routine.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addRoutine(Routine routine) async {
    await _db.collection('routines').add(routine.toMap());
  }

  Future<void> deleteRoutine(String id) async {
    await _db.collection('routines').doc(id).delete();
  }
}
