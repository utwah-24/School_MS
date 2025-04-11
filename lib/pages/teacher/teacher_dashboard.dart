import 'package:flutter/material.dart';
import '/main.dart';
import '/utils/constants.dart';
import '/pages/teacher/upload_results.dart';
import '/pages/teacher/assign_homework.dart';
import '/widgets/dashboard_card.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final Map<String, dynamic> _teacherInfo = {};
  String _teacherName = 'Teacher';
  String _schoolName = 'School';
  int _selectedIndex = 0;
  bool _isLoading = true;
  
  final List<Widget> _pages = const [
    TeacherHomePage(),
    UploadResultsPage(),
    AssignHomeworkPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadTeacherInfo();
  }

  Future<void> _loadTeacherInfo() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final teacherData = await supabase
          .from('teachers')
          .select('*, schools:school_id(school_name)')
          .eq('id', userId)
          .single();
      
      setState(() {
        _teacherInfo.addAll(teacherData);
        _teacherName = '${teacherData['first_name']} ${teacherData['last_name']}';
        _schoolName = teacherData['schools']['school_name'] ?? 'School';
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load teacher information', isError: true);
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
        title: Text('$_schoolName - Teacher Portal'),
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
                    _teacherName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _teacherInfo['subjects'] ?? 'Teacher',
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
              leading: const Icon(Icons.grading),
              title: const Text('Upload Results'),
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
              title: const Text('Assign Homework'),
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
              leading: const Icon(Icons.people),
              title: const Text('View Students'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to view students page
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Announcements'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to announcements page
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

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teacher Dashboard',
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
                  title: 'My Students',
                  value: '58',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: 'My Classes',
                  value: '4',
                  icon: Icons.class_,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: 'Pending Marks',
                  value: '12',
                  icon: Icons.grading,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: 'Assigned Homework',
                  value: '3',
                  icon: Icons.assignment,
                  color: Colors.purple,
                ),
                DashboardCard(
                  title: 'Announcements',
                  value: '2',
                  icon: Icons.announcement,
                  color: Colors.teal,
                ),
                DashboardCard(
                  title: 'Upcoming Events',
                  value: '1',
                  icon: Icons.event,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
