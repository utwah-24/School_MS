class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final String role; // 'admin', 'owner', 'teacher', 'student'
  final String? schoolId;
  final String? schoolName;
  final String? phoneNumber;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
    this.schoolId,
    this.schoolName,
    this.phoneNumber,
    this.address,
  });
}
