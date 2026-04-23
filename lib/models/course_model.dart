class Course {
  String id;
  String name;
  List<String> days;
  String startTime;
  String endTime;
  String room;

  Course({
    required this.id,
    required this.name,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  // 1. Unpack data coming from Firebase
  factory Course.fromMap(Map<String, dynamic> map, String documentId) {
    return Course(
      id: documentId, // Firestore provides the ID separately
      name: map['name'] ?? '',
      days: List<String>.from(map['days'] ?? []),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      room: map['room'] ?? '',
    );
  }

  // 2. Package data to send to Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      // We don't send the ID; Firestore auto-generates it for us!
    };
  }
}
