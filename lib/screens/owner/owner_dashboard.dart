import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/screens/owner/manage_students_screen.dart';
import 'package:flutter_web_dashboard/screens/owner/manage_teachers_screen.dart';
import 'package:flutter_web_dashboard/widgets/dashboard_card.dart';
import 'package:flutter_web_dashboard/widgets/sidebar_menu.dart';
import '/mixins/dashboard_animation_mixin.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard>
    with SingleTickerProviderStateMixin, DashboardAnimationMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data
  final String _schoolName = 'Sunshine Academy';
  final int _studentCount = 450;
  final int _teacherCount = 35;
  final int _classesCount = 15;

  // Define menu items and their corresponding screens
  late final List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      screen: _buildDashboardContent(),
    ),
    SidebarMenuItem(
      title: 'Manage Students',
      icon: Icons.people,
      screen: const ManageStudentsScreen(),
    ),
    SidebarMenuItem(
      title: 'Manage Teachers',
      icon: Icons.person,
      screen: const ManageTeachersScreen(),
    ),
    SidebarMenuItem(
      title: 'Classes',
      icon: Icons.class_,
      screen: const Center(child: Text('Classes Screen')),
    ),
    SidebarMenuItem(
      title: 'Exams & Results',
      icon: Icons.assessment,
      screen: const Center(child: Text('Exams & Results Screen')),
    ),
    SidebarMenuItem(
      title: 'Announcements',
      icon: Icons.campaign,
      screen: const Center(child: Text('Announcements Screen')),
    ),
    SidebarMenuItem(
      title: 'Settings',
      icon: Icons.settings,
      screen: const Center(child: Text('Settings Screen')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              if (isMobile)
                IconButton(
                  icon: const Icon(Icons.menu, size: 28),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
              if (isMobile) const SizedBox(width: 16),

              // School logo and name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.school,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _schoolName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              const Spacer(),

              // Notifications
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {
                      // Show notifications
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      drawer: isMobile
          ? SidebarMenu(
              username: 'School Owner',
              role: 'School Administrator',
              schoolName: _schoolName,
              menuItems: _menuItems,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context);
              },
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            SizedBox(
              width: 280,
              child: SidebarMenu(
                username: 'School Owner',
                role: 'School Administrator',
                schoolName: _schoolName,
                menuItems: _menuItems,
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: Colors.grey[100],
              child: _menuItems[_selectedIndex].screen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return buildAnimatedContent(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAnimatedCard(
                delay: 0.0,
                child: _buildWelcomeSection(),
              ),
              const SizedBox(height: 24),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.1,
                      child: _buildStatCard(
                        'Total Students',
                        _studentCount.toString(),
                        Icons.people,
                        Colors.blue,
                        'Currently enrolled',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.2,
                      child: _buildStatCard(
                        'Total Teachers',
                        _teacherCount.toString(),
                        Icons.person,
                        Colors.orange,
                        'Active faculty members',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.3,
                      child: _buildStatCard(
                        'Total Classes',
                        _classesCount.toString(),
                        Icons.class_,
                        Colors.green,
                        'Active classes',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              buildAnimatedCard(
                delay: 0.4,
                child: _buildRecentActivitiesSection(),
              ),
              const SizedBox(height: 24),

              buildAnimatedCard(
                delay: 0.5,
                child: _buildQuickActionsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          buildScaleAnimation(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'School Administrator',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildProfileChip(Icons.school, _schoolName),
                    const SizedBox(width: 12),
                    _buildProfileChip(Icons.verified, 'Owner'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    final activities = [
      {
        'title': 'New Student Registered',
        'description': 'John Doe was added to Class 10A',
        'time': '2 hours ago',
        'icon': Icons.person_add,
        'color': Colors.blue,
      },
      {
        'title': 'Exam Results Published',
        'description': 'Mid-term exam results for Class 8B',
        'time': '1 day ago',
        'icon': Icons.assessment,
        'color': Colors.green,
      },
      {
        'title': 'New Teacher Joined',
        'description': 'Sarah Johnson - Mathematics',
        'time': '2 days ago',
        'icon': Icons.person_add,
        'color': Colors.orange,
      },
      {
        'title': 'Announcement Posted',
        'description': 'Annual Sports Day Schedule',
        'time': '3 days ago',
        'icon': Icons.campaign,
        'color': Colors.purple,
      },
      {
        'title': 'Fee Payment Received',
        'description': 'Term fees received from 15 students',
        'time': '5 days ago',
        'icon': Icons.payment,
        'color': Colors.red,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text('View All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['description'] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionButton(
                icon: Icons.person_add,
                label: 'Add Student',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildQuickActionButton(
                icon: Icons.person_add,
                label: 'Add Teacher',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildQuickActionButton(
                icon: Icons.campaign,
                label: 'Announcement',
                onTap: () => setState(() => _selectedIndex = 5),
              ),
              _buildQuickActionButton(
                icon: Icons.assessment,
                label: 'Results',
                onTap: () => setState(() => _selectedIndex = 4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
