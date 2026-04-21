class Student {
  String? docId; // The hidden Firebase ID
  String id; // The visible University ID
  String name;
  String email;
  List<String> enrolledCourseIds;

  Student({
    this.docId,
    required this.id,
    required this.name,
    required this.email,
    required this.enrolledCourseIds,
  });

  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      docId: documentId,
      id: map['universityId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      enrolledCourseIds: List<String>.from(map['enrolledCourseIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'universityId': id,
      'name': name,
      'email': email,
      'enrolledCourseIds': enrolledCourseIds,
    };
  }
}
