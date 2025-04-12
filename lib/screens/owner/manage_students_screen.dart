import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/widgets/custom_button.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedClass = 'All Classes';

  // Mock data
  final List<Map<String, dynamic>> _students = [
    {
      'id': 'student00001@sunshine',
      'name': 'John Doe',
      'class': 'Class 10A',
      'gender': 'Male',
      'phone': '+1234567890',
      'email': 'john.doe@example.com',
      'address': '123 Main St, City',
      'joinDate': '01/09/2023',
    },
    {
      'id': 'student00002@sunshine',
      'name': 'Jane Smith',
      'class': 'Class 10A',
      'gender': 'Female',
      'phone': '+0987654321',
      'email': 'jane.smith@example.com',
      'address': '456 Oak St, Town',
      'joinDate': '01/09/2023',
    },
    {
      'id': 'student00003@sunshine',
      'name': 'Michael Johnson',
      'class': 'Class 9B',
      'gender': 'Male',
      'phone': '+1122334455',
      'email': 'michael.j@example.com',
      'address': '789 Pine St, Village',
      'joinDate': '01/09/2023',
    },
    {
      'id': 'student00004@sunshine',
      'name': 'Emily Brown',
      'class': 'Class 9B',
      'gender': 'Female',
      'phone': '+5566778899',
      'email': 'emily.b@example.com',
      'address': '101 Elm St, County',
      'joinDate': '01/09/2023',
    },
    {
      'id': 'student00005@sunshine',
      'name': 'David Wilson',
      'class': 'Class 8C',
      'gender': 'Male',
      'phone': '+1212343456',
      'email': 'david.w@example.com',
      'address': '202 Maple St, District',
      'joinDate': '01/09/2023',
    },
  ];

  final List<String> _classes = [
    'All Classes',
    'Class 10A',
    'Class 9B',
    'Class 8C',
    'Class 7D',
    'Class 6E',
  ];

  late List<Map<String, dynamic>> _filteredStudents;

  @override
  void initState() {
    super.initState();
    _filteredStudents = _students;
    _searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        final matchesQuery = student['name'].toLowerCase().contains(query) ||
            student['id'].toLowerCase().contains(query) ||
            student['email'].toLowerCase().contains(query);

        final matchesClass = _selectedClass == 'All Classes' ||
            student['class'] == _selectedClass;

        return matchesQuery && matchesClass;
      }).toList();
    });
  }

  void _filterByClass(String className) {
    setState(() {
      _selectedClass = className;
      _filterStudents();
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
            'Manage Students',
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
                value: _selectedClass,
                items: _classes.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _filterByClass(newValue);
                  }
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Student'),
                onPressed: () {
                  _showAddStudentDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Students list
          Expanded(
            child: _filteredStudents.isEmpty
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
                          'No students found',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
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
                                      student['name'][0],
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
                                          student['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'ID: ${student['id']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              student['email'],
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
                                              student['phone'],
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
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.class_,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        student['class'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Joined: ${student['joinDate']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit Student',
                                        onPressed: () {
                                          _showEditStudentDialog(
                                              context, student);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        tooltip: 'Delete Student',
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context, student);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
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

  void _showAddStudentDialog(BuildContext context) {
    // TODO: Implement add student dialog
  }

  void _showEditStudentDialog(
      BuildContext context, Map<String, dynamic> student) {
    // TODO: Implement edit student dialog
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> student) {
    // TODO: Implement delete confirmation dialog
  }
}
