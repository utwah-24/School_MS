class School {
  final String id;
  final String name;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String address;
  final DateTime createdAt;
  final int studentCount;
  final int teacherCount;

  School({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.address,
    required this.createdAt,
    this.studentCount = 0,
    this.teacherCount = 0,
  });
}
