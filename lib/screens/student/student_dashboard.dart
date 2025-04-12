import 'package:flutter/material.dart';
import '/widgets/dashboard_card.dart';
import '/widgets/sidebar_menu.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock data
  final String _studentName = 'John Doe';
  final String _schoolName = 'Sunshine Academy';
  final String _className = 'Class 10A';
  final String _rollNumber = 'student00001@sunshine';

  // Define menu items and their corresponding screens
  late final List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      screen: _buildDashboardContent(),
    ),
    SidebarMenuItem(
      title: 'My Results',
      icon: Icons.assessment,
      screen: const Center(child: Text('My Results Screen')),
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
      title: 'Fee Payments',
      icon: Icons.payment,
      screen: const Center(child: Text('Fee Payments Screen')),
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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMenuItemSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

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
              // Only show hamburger menu on mobile
              if (isMobile)
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 28,
                  ),
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
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 28,
                    ),
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
              username: _studentName,
              role: 'Student',
              schoolName: '$_className, $_schoolName',
              menuItems: _menuItems,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                _onMenuItemSelected(index);
                Navigator.pop(context);
              },
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Permanent sidebar for desktop
          if (!isMobile)
            SizedBox(
              width: 280,
              child: SidebarMenu(
                username: _studentName,
                role: 'Student',
                schoolName: '$_className, $_schoolName',
                menuItems: _menuItems,
                selectedIndex: _selectedIndex,
                onItemSelected: _onMenuItemSelected,
              ),
            ),
          // Main content
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
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
                    // Welcome Section with Profile
                    _buildAnimatedCard(
                      delay: 0.0,
                      child: _buildWelcomeSection(),
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats Section
                    Row(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          Expanded(
                            child: _buildAnimatedCard(
                              delay: 0.1 * (i + 1),
                              child: _buildStatCards()[i],
                            ),
                          ),
                          if (i < 2) const SizedBox(width: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Schedule Section
                    _buildAnimatedCard(
                      delay: 0.4,
                      child: _buildScheduleSection(),
                    ),
                    const SizedBox(height: 24),

                    // Activities Section
                    _buildAnimatedCard(
                      delay: 0.5,
                      child: _buildActivitiesSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required double delay, required Widget child}) {
    final Animation<double> delayedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: delayedAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - delayedAnimation.value)),
          child: Opacity(
            opacity: delayedAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Helper method to get stat cards
  List<Widget> _buildStatCards() {
    return [
      _buildStatCard(
        'Attendance',
        '92%',
        Icons.fact_check_rounded,
        Colors.green,
        'Present: 92 days | Absent: 8 days',
      ),
      _buildStatCard(
        'Current Rank',
        '5th',
        Icons.emoji_events_rounded,
        Colors.orange,
        'Class Average: 85%',
      ),
      _buildStatCard(
        'Upcoming Tests',
        '3',
        Icons.assignment_rounded,
        Colors.blue,
        'Next: Mathematics (Tomorrow)',
      ),
    ];
  }

  // Extract the welcome section
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
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 1000),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
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
                  _studentName[0],
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
                  _studentName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildProfileChip(Icons.school, _className),
                    const SizedBox(width: 12),
                    _buildProfileChip(Icons.badge, _rollNumber),
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
              final subjects = [
                {
                  'name': 'Mathematics',
                  'teacher': 'Mr. Robert Johnson',
                  'time': '8:00 AM - 9:00 AM',
                  'color': Colors.blue,
                  'room': 'Room 101',
                  'status': 'Ongoing',
                },
                {
                  'name': 'Science',
                  'teacher': 'Mrs. Sarah Williams',
                  'time': '9:15 AM - 10:15 AM',
                  'color': Colors.green,
                  'room': 'Lab 3',
                  'status': 'Next',
                },
                {
                  'name': 'English',
                  'teacher': 'Mr. James Brown',
                  'time': '10:30 AM - 11:30 AM',
                  'color': Colors.orange,
                  'room': 'Room 205',
                  'status': 'Upcoming',
                },
                {
                  'name': 'History',
                  'teacher': 'Ms. Emily Davis',
                  'time': '12:00 PM - 1:00 PM',
                  'color': Colors.purple,
                  'room': 'Room 304',
                  'status': 'Upcoming',
                },
              ];

              final subject = subjects[index];
              final isOngoing = subject['status'] == 'Ongoing';
              final isNext = subject['status'] == 'Next';

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isOngoing
                      ? (subject['color'] as Color).withOpacity(0.1)
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
                        color: subject['color'] as Color,
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
                                subject['name'] as String,
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
                            subject['teacher'] as String,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          subject['time'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject['room'] as String,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
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
                  'title': 'Assignment Submitted',
                  'description': 'Mathematics - Algebra Equations',
                  'time': '2 hours ago',
                  'icon': Icons.assignment_turned_in,
                  'color': Colors.green,
                },
                {
                  'title': 'Test Result Published',
                  'description': 'Science - Mid-term Exam',
                  'time': '1 day ago',
                  'icon': Icons.assessment,
                  'color': Colors.blue,
                },
                {
                  'title': 'New Assignment',
                  'description': 'English - Essay Writing',
                  'time': '2 days ago',
                  'icon': Icons.assignment,
                  'color': Colors.orange,
                },
                {
                  'title': 'Fee Payment',
                  'description': 'Term 2 Fees - Paid',
                  'time': '3 days ago',
                  'icon': Icons.payment,
                  'color': Colors.purple,
                },
                {
                  'title': 'Announcement',
                  'description': 'Annual Sports Day Schedule',
                  'time': '5 days ago',
                  'icon': Icons.campaign,
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
