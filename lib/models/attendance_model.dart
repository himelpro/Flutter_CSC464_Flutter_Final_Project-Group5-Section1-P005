class AttendanceRecord {
  String? docId;
  String date;
  String courseId;
  Map<String, bool> studentAttendance;

  AttendanceRecord({
    this.docId,
    required this.date,
    required this.courseId,
    required this.studentAttendance,
  });

  factory AttendanceRecord.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return AttendanceRecord(
      docId: documentId,
      date: map['date'] ?? '',
      courseId: map['courseId'] ?? '',
      studentAttendance: Map<String, bool>.from(map['studentAttendance'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'courseId': courseId,
      'studentAttendance': studentAttendance,
    };
  }
}
