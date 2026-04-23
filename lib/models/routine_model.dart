class Routine {
  String id;
  String title;
  String type;
  String date;
  String startTime;
  String endTime;
  String room;

  Routine({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  // Unpack from Firebase
  factory Routine.fromMap(Map<String, dynamic> map, String documentId) {
    return Routine(
      id: documentId, // Firestore auto-ID
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      room: map['room'] ?? '',
    );
  }

  // Package for Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
    };
  }
}
