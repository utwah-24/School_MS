import 'package:flutter/material.dart';
import '/widgets/dashboard_card.dart';
import '/widgets/sidebar_menu.dart';
import '/mixins/dashboard_animation_mixin.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with SingleTickerProviderStateMixin, DashboardAnimationMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data
  final String _teacherName = 'Robert Johnson';
  final String _schoolName = 'Sunshine Academy';
  final String _department = 'Mathematics';
  final List<String> _assignedClasses = ['Class 10A', 'Class 9B', 'Class 8C'];
  final int _totalStudents = 120;

  // Define menu items and their corresponding screens
  late final List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      screen: _buildDashboardContent(),
    ),
    SidebarMenuItem(
      title: 'My Classes',
      icon: Icons.class_,
      screen: const Center(child: Text('My Classes Screen')),
    ),
    SidebarMenuItem(
      title: 'Upload Results',
      icon: Icons.upload_file,
      screen: const Center(child: Text('Upload Results Screen')),
    ),
    SidebarMenuItem(
      title: 'Assignments',
      icon: Icons.assignment,
      screen: const Center(child: Text('Assignments Screen')),
    ),
    SidebarMenuItem(
      title: 'Attendance',
      icon: Icons.fact_check,
      screen: const Center(child: Text('Attendance Screen')),
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
              username: _teacherName,
              role: 'Teacher - $_department',
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
                username: _teacherName,
                role: 'Teacher - $_department',
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
              Row(
                children: [
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.1,
                      child: _buildStatCard(
                        'Total Students',
                        '$_totalStudents',
                        Icons.people,
                        Colors.blue,
                        'Across ${_assignedClasses.length} classes',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.2,
                      child: _buildStatCard(
                        'Pending Tasks',
                        '5',
                        Icons.assignment_late,
                        Colors.orange,
                        '3 assignments, 2 results pending',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildAnimatedCard(
                      delay: 0.3,
                      child: _buildStatCard(
                        'Today\'s Classes',
                        '4',
                        Icons.class_,
                        Colors.green,
                        'Next: Class 10A Mathematics',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              buildAnimatedCard(
                delay: 0.4,
                child: _buildScheduleSection(),
              ),
              const SizedBox(height: 24),
              buildAnimatedCard(
                delay: 0.5,
                child: _buildActivitiesSection(),
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
                child: Text(
                  _teacherName[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
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
                  _teacherName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildProfileChip(Icons.school, _department),
                    const SizedBox(width: 12),
                    _buildProfileChip(
                        Icons.class_, '${_assignedClasses.length} Classes'),
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

  Widget _buildScheduleSection() {
    // Similar to StudentDashboard's schedule section
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Schedule',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monday, 4 Classes',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('View Full Schedule'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              final classes = [
                {
                  'name': 'Class 10A',
                  'subject': 'Mathematics',
                  'time': '8:00 AM - 9:00 AM',
                  'color': Colors.blue,
                  'room': 'Room 101',
                  'status': 'Ongoing',
                },
                {
                  'name': 'Class 9B',
                  'subject': 'Mathematics',
                  'time': '9:15 AM - 10:15 AM',
                  'color': Colors.green,
                  'room': 'Room 203',
                  'status': 'Next',
                },
                {
                  'name': 'Class 8C',
                  'subject': 'Mathematics',
                  'time': '10:30 AM - 11:30 AM',
                  'color': Colors.orange,
                  'room': 'Room 105',
                  'status': 'Upcoming',
                },
                {
                  'name': 'Class 10B',
                  'subject': 'Mathematics',
                  'time': '12:00 PM - 1:00 PM',
                  'color': Colors.purple,
                  'room': 'Room 302',
                  'status': 'Upcoming',
                },
              ];

              final classInfo = classes[index];
              final isOngoing = classInfo['status'] == 'Ongoing';
              final isNext = classInfo['status'] == 'Next';

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isOngoing
                      ? (classInfo['color'] as Color).withOpacity(0.1)
                      : null,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: classInfo['color'] as Color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${classInfo['name']} - ${classInfo['subject']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (isOngoing) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Ongoing',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ] else if (isNext) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            classInfo['room'] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      classInfo['time'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
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

  Widget _buildActivitiesSection() {
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
            itemCount: 5,
            itemBuilder: (context, index) {
              final activities = [
                {
                  'title': 'Assignment Created',
                  'description': 'Class 10A - Algebra Exercise',
                  'time': '2 hours ago',
                  'icon': Icons.assignment_add,
                  'color': Colors.blue,
                },
                {
                  'title': 'Results Uploaded',
                  'description': 'Class 9B - Mid-term Test',
                  'time': '1 day ago',
                  'icon': Icons.upload_file,
                  'color': Colors.green,
                },
                {
                  'title': 'Attendance Marked',
                  'description': 'Class 8C - Morning Session',
                  'time': '2 days ago',
                  'icon': Icons.fact_check,
                  'color': Colors.orange,
                },
                {
                  'title': 'Announcement Posted',
                  'description': 'Class 10A - Exam Schedule',
                  'time': '3 days ago',
                  'icon': Icons.campaign,
                  'color': Colors.purple,
                },
                {
                  'title': 'Assignment Graded',
                  'description': 'Class 9B - 25 submissions',
                  'time': '5 days ago',
                  'icon': Icons.grading,
                  'color': Colors.red,
                },
              ];

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
}
