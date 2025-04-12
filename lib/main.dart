import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/screens/login_screen.dart';
import 'package:flutter_web_dashboard/theme/app_theme.dart';

import 'screens/student/student_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shule Kingajani',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
     
      home: const LoginScreen(),
    );
  }
}
