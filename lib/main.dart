import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import './pages/login_page.dart';
import './pages/admin/admin_dashboard.dart';
import './pages/owner/owner_dashboard.dart';
import './pages/teacher/teacher_dashboard.dart';
import './pages/student/student_dashboard.dart';
import './utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.teal,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      home: StudentDashboard(),
    );
  }
}

// class AuthRouter extends StatelessWidget {
//   const AuthRouter({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<AuthState>(
//       stream: supabase.auth.onAuthStateChange,
//       builder: (context, snapshot) {
//         // Check if user is authenticated
//         if (snapshot.hasData && snapshot.data!.session != null) {
//           final session = snapshot.data!.session!;
//           // Get user role from claims or metadata
//           final role = session.user.userMetadata?['role'] as String? ?? '';
          
//           // Route to appropriate dashboard based on user role
//           switch (role) {
//             case UserRoles.admin:
//               return const AdminDashboard();
//             case UserRoles.owner:
//               return const OwnerDashboard();
//             case UserRoles.teacher:
//               return const TeacherDashboard();
//             case UserRoles.student:
//               return const StudentDashboard();
//             default:
//               // If role is not set, log out
//               supabase.auth.signOut();
//               return const LoginPage();
//           }
//         }
        
//         // Not authenticated, show login page
//         return const LoginPage();
//       },
//     );
//   }
// }
