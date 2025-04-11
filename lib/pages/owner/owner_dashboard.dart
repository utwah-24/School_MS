import 'package:flutter/material.dart';
import '/main.dart';
import '/utils/constants.dart';
import '/pages/owner/add_student.dart';
import '/pages/owner/add_teacher.dart';
import '/pages/owner/school_statistics.dart';
import '/widgets/dashboard_card.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final Map<String, dynamic> _schoolInfo = {};
  String _ownerName = 'School Owner';
  String _schoolName = 'My School';
  int _selectedIndex = 0;
  bool _isLoading = true;
  
  final List<Widget> _pages = [
    const OwnerHomePage(),
    const AddStudentPage(),
    const AddTeacherPage(),
    const SchoolStatisticsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadSchoolInfo();
  }

  Future<void> _loadSchoolInfo() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final schoolData = await supabase
          .from('schools')
          .select()
          .eq('id', userId)
          .single();
      
      setState(() {
        _schoolInfo.addAll(schoolData);
        _ownerName = schoolData['owner_name'] ?? 'School Owner';
        _schoolName = schoolData['school_name'] ?? 'My School';
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load school information', isError: true);
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
        title: Text(_schoolName),
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
                    _ownerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _schoolName,
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
              leading: const Icon(Icons.person_add),
              title: const Text('Add Student'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Add Teacher'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('School Statistics'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Students'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to manage students page
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Manage Teachers'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to manage teachers page
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
              leading: const Icon(Icons.settings),
              title: const Text('School Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
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

class OwnerHomePage extends StatelessWidget {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School Dashboard',
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
                  title: 'Total Students',
                  value: '215',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                DashboardCard(
                  title: 'Total Teachers',
                  value: '24',
                  icon: Icons.school,
                  color: Colors.green,
                ),
                DashboardCard(
                  title: 'Classes',
                  value: '12',
                  icon: Icons.class_,
                  color: Colors.orange,
                ),
                DashboardCard(
                  title: 'Pending Payments',
                  value: '8',
                  icon: Icons.payment,
                  color: Colors.red,
                ),
                DashboardCard(
                  title: 'Announcements',
                  value: '3',
                  icon: Icons.announcement,
                  color: Colors.purple,
                ),
                DashboardCard(
                  title: 'Upcoming Events',
                  value: '2',
                  icon: Icons.event,
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
