import 'package:flutter/material.dart';
import '/main.dart';
import '/utils/constants.dart';
import '/pages/student/view_results.dart';
import '/pages/student/view_homework.dart';
import '/widgets/dashboard_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final Map<String, dynamic> _studentInfo = {};
  String _studentName = 'Student';
  String _schoolName = 'School';
  String _studentClass = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  
  final List<Widget> _pages = const [
    StudentHomePage(),
    ViewResultsPage(),
    ViewHomeworkPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final studentData = await supabase
          .from('students')
          .select('*, schools:school_id(school_name)')
          .eq('id', userId)
          .single();
      
      setState(() {
        _studentInfo.addAll(studentData);
        _studentName = '${studentData['first_name']} ${studentData['last_name']}';
        _schoolName = studentData['schools']['school_name'] ?? 'School';
        _studentClass = studentData['grade'] ?? '';
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load student information', isError: true);
      }
    }
  }

  void _signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error signing out', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$_schoolName - Student Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                
                  Text(
                    _studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Class: $_studentClass',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('View Results'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Homework'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Announcements'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to announcements page
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to payments page
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                DashboardCard(
                  title: 'Assignments Due',
                  value: '3',
                  icon: Icons.assignment,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: 'Upcoming Tests',
                  value: '2',
                  icon: Icons.fact_check,
                  color: Colors.purple,
                ),
                DashboardCard(
                  title: 'Attendance',
                  value: '92%',
                  icon: Icons.calendar_today,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: 'Overall Grade',
                  value: 'A',
                  icon: Icons.school,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: 'Announcements',
                  value: '4',
                  icon: Icons.announcement,
                  color: Colors.red,
                ),
                DashboardCard(
                  title: 'Library Books',
                  value: '1',
                  icon: Icons.book,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
