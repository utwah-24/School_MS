import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/school.dart';
import 'package:flutter_web_dashboard/screens/admin/create_owner_screen.dart';
import 'package:flutter_web_dashboard/screens/admin/manage_owners_screen.dart';
import 'package:flutter_web_dashboard/screens/admin/reset_password_screen.dart';
import 'package:flutter_web_dashboard/widgets/dashboard_card.dart';
import 'package:flutter_web_dashboard/widgets/sidebar_menu.dart';
import '/mixins/dashboard_animation_mixin.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin, DashboardAnimationMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for schools
  final List<School> _schools = [
    School(
      id: '1',
      name: 'Sunshine Academy',
      ownerName: 'John Doe',
      ownerEmail: 'john@example.com',
      ownerPhone: '+1234567890',
      address: '123 Main St, City',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      studentCount: 450,
      teacherCount: 35,
    ),
    School(
      id: '2',
      name: 'Bright Future School',
      ownerName: 'Jane Smith',
      ownerEmail: 'jane@example.com',
      ownerPhone: '+0987654321',
      address: '456 Oak St, Town',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      studentCount: 320,
      teacherCount: 28,
    ),
    School(
      id: '3',
      name: 'Excellence College',
      ownerName: 'Robert Johnson',
      ownerEmail: 'robert@example.com',
      ownerPhone: '+1122334455',
      address: '789 Pine St, Village',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      studentCount: 580,
      teacherCount: 42,
    ),
  ];

  // Define menu items and their corresponding screens
  late final List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      screen: _buildDashboardContent(),
    ),
    SidebarMenuItem(
      title: 'Create School Owner',
      icon: Icons.person_add,
      screen: const CreateOwnerScreen(),
    ),
    SidebarMenuItem(
      title: 'Manage School Owners',
      icon: Icons.people,
      screen: ManageOwnersScreen(schools: _schools),
    ),
    SidebarMenuItem(
      title: 'Reset Passwords',
      icon: Icons.password,
      screen: const ResetPasswordScreen(),
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

              // System logo and name
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
                      Icons.admin_panel_settings,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'School Management System',
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
              username: 'Admin',
              role: 'System Administrator',
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
                username: 'Admin',
                role: 'System Administrator',
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
                        'Total Schools',
                        _schools.length.toString(),
                        Icons.school,
                        Colors.blue,
                        'Active and running schools',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.2,
                      child: _buildStatCard(
                        'Total Students',
                        _schools
                            .fold(0, (sum, school) => sum + school.studentCount)
                            .toString(),
                        Icons.people,
                        Colors.orange,
                        'Across all schools',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.3,
                      child: _buildStatCard(
                        'Total Teachers',
                        _schools
                            .fold(0, (sum, school) => sum + school.teacherCount)
                            .toString(),
                        Icons.person,
                        Colors.green,
                        'Across all schools',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              buildAnimatedCard(
                delay: 0.4,
                child: _buildRecentSchoolsSection(),
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
                  Icons.admin_panel_settings,
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
                  'System Administrator',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildProfileChip(
                        Icons.school, '${_schools.length} Schools'),
                    const SizedBox(width: 12),
                    _buildProfileChip(Icons.verified, 'Super Admin'),
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

  Widget _buildRecentSchoolsSection() {
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
                  'Recent Schools',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1; // Navigate to Create School Owner
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New School'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _schools.length,
            itemBuilder: (context, index) {
              final school = _schools[index];
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        school.name[0],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Owner: ${school.ownerName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${school.studentCount} students',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${school.teacherCount} teachers',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                label: 'Add School',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildQuickActionButton(
                icon: Icons.people,
                label: 'Manage Schools',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildQuickActionButton(
                icon: Icons.password,
                label: 'Reset Password',
                onTap: () => setState(() => _selectedIndex = 3),
              ),
              _buildQuickActionButton(
                icon: Icons.settings,
                label: 'Settings',
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
