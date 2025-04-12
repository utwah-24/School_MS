import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/widgets/custom_button.dart';

class ManageTeachersScreen extends StatefulWidget {
  const ManageTeachersScreen({super.key});

  @override
  State<ManageTeachersScreen> createState() => _ManageTeachersScreenState();
}

class _ManageTeachersScreenState extends State<ManageTeachersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'All Departments';

  // Mock data
  final List<Map<String, dynamic>> _teachers = [
    {
      'id': 'teacher00001@sunshine',
      'name': 'Robert Johnson',
      'department': 'Mathematics',
      'gender': 'Male',
      'phone': '+1234567890',
      'email': 'robert.j@example.com',
      'address': '123 Main St, City',
      'joinDate': '01/06/2022',
      'classes': ['Class 10A', 'Class 9B', 'Class 8C'],
    },
    {
      'id': 'teacher00002@sunshine',
      'name': 'Sarah Williams',
      'department': 'Science',
      'gender': 'Female',
      'phone': '+0987654321',
      'email': 'sarah.w@example.com',
      'address': '456 Oak St, Town',
      'joinDate': '15/07/2022',
      'classes': ['Class 10A', 'Class 9B'],
    },
    {
      'id': 'teacher00003@sunshine',
      'name': 'James Brown',
      'department': 'English',
      'gender': 'Male',
      'phone': '+1122334455',
      'email': 'james.b@example.com',
      'address': '789 Pine St, Village',
      'joinDate': '10/08/2022',
      'classes': ['Class 8C', 'Class 7D'],
    },
    {
      'id': 'teacher00004@sunshine',
      'name': 'Emily Davis',
      'department': 'History',
      'gender': 'Female',
      'phone': '+5566778899',
      'email': 'emily.d@example.com',
      'address': '101 Elm St, County',
      'joinDate': '05/09/2022',
      'classes': ['Class 9B', 'Class 7D'],
    },
    {
      'id': 'teacher00005@sunshine',
      'name': 'Michael Wilson',
      'department': 'Physical Education',
      'gender': 'Male',
      'phone': '+1212343456',
      'email': 'michael.w@example.com',
      'address': '202 Maple St, District',
      'joinDate': '20/10/2022',
      'classes': ['Class 10A', 'Class 9B', 'Class 8C', 'Class 7D', 'Class 6E'],
    },
  ];

  final List<String> _departments = [
    'All Departments',
    'Mathematics',
    'Science',
    'English',
    'History',
    'Physical Education',
  ];

  late List<Map<String, dynamic>> _filteredTeachers;

  @override
  void initState() {
    super.initState();
    _filteredTeachers = _teachers;
    _searchController.addListener(_filterTeachers);
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers = _teachers.where((teacher) {
        final matchesQuery = teacher['name'].toLowerCase().contains(query) ||
            teacher['id'].toLowerCase().contains(query) ||
            teacher['email'].toLowerCase().contains(query);

        final matchesDepartment = _selectedDepartment == 'All Departments' ||
            teacher['department'] == _selectedDepartment;

        return matchesQuery && matchesDepartment;
      }).toList();
    });
  }

  void _filterByDepartment(String department) {
    setState(() {
      _selectedDepartment = department;
      _filterTeachers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Teachers',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Search and filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, ID or email',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedDepartment,
                items: _departments.map((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _filterByDepartment(newValue);
                  }
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Teacher'),
                onPressed: () {
                  _showAddTeacherDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Teachers list
          Expanded(
            child: _filteredTeachers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No teachers found',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = _filteredTeachers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    child: Text(
                                      teacher['name'][0],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          teacher['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${teacher['id']}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Chip(
                                              label:
                                                  Text(teacher['department']),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1),
                                              labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Chip(
                                              label: Text(teacher['gender']),
                                              backgroundColor: Colors.grey[200],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit Teacher',
                                        onPressed: () {
                                          // Edit teacher
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.key),
                                        tooltip: 'Reset Password',
                                        onPressed: () {
                                          // Reset password
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        tooltip: 'Delete Teacher',
                                        onPressed: () {
                                          // Delete teacher
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              teacher['email'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              teacher['phone'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              teacher['address'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Joined: ${teacher['joinDate']}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Assigned Classes:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: (teacher['classes'] as List<String>)
                                    .map((className) {
                                  return Chip(
                                    label: Text(className),
                                    backgroundColor: Colors.grey[200],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddTeacherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Teacher'),
        content: const Text('This would open a form to add a new teacher.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Add Teacher'),
          ),
        ],
      ),
    );
  }
}
