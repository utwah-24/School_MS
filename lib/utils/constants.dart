import 'package:flutter/material.dart';

class UserRoles {
  static const String admin = 'admin';
  static const String owner = 'owner';
  static const String teacher = 'teacher';
  static const String student = 'student';
}

class AppRoutes {
  static const String login = '/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String ownerDashboard = '/owner/dashboard';
  static const String teacherDashboard = '/teacher/dashboard';
  static const String studentDashboard = '/student/dashboard';
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(this).colorScheme.error : Theme.of(this).colorScheme.primary,
      ),
    );
  }
}
