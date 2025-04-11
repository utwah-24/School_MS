import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class ViewHomeworkPage extends StatefulWidget {
  const ViewHomeworkPage({super.key});

  @override
  State<ViewHomeworkPage> createState() => _ViewHomeworkPageState();
}

class _ViewHomeworkPageState extends State<ViewHomeworkPage> {
  List<Map<String, dynamic>> _homeworkList = [];
  bool _isLoading = true;
  String? _selectedSubject;
  String _studentClass = '';
  List<String> _subjects = [];
  
  @override
  void initState() {
    super.initState();
    _loadHomework();
  }
  
  Future<void> _loadHomework() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Get student class
      final studentData = await supabase
          .from('students')
          .select('grade')
          .eq('id', userId)
          .single();
      
      _studentClass = studentData['grade'] as String;
      
      // Get homework for the student's class
      final homeworkResponse = await supabase
          .from('homework')
          .select('*, teachers:teacher_id(first_name, last_name)')
          .eq('class', _studentClass)
          .order('due_date', ascending: true);
      
      final homeworkList = List<Map<String, dynamic>>.from(homeworkResponse);
      
      // Extract unique subjects
      final subjectsSet = <String>{};
      for (final homework in homeworkList) {
        subjectsSet.add(homework['subject'] as String);
      }
      
      setState(() {
        _homeworkList = homeworkList;
        _subjects = subjectsSet.toList()..sort();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load homework: $error', isError: true);
      }
    }
  }
  
  List<Map<String, dynamic>> _getFilteredHomework() {
    if (_selectedSubject == null) {
      return _homeworkList;
    }
    return _homeworkList.where((homework) => homework['subject'] == _selectedSubject).toList();
  }
  
  bool _isHomeworkOverdue(String dueDateString) {
    final dueDate = DateTime.parse(dueDateString).toLocal();
    final now = DateTime.now();
    return now.isAfter(dueDate);
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredHomework = _getFilteredHomework();
    
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Homework Assignments',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Subject filter
          DropdownButtonFormField<String?>(
            decoration: const InputDecoration(
              labelText: 'Filter by Subject',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.filter_list),
            ),
            value: _selectedSubject,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All Subjects'),
              ),
              ..._subjects.map((subject) {
                return DropdownMenuItem<String?>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSubject = value;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Homework list
          Expanded(
            child: filteredHomework.isEmpty
                ? const Center(
                    child: Text('No homework assignments found'),
                  )
                : ListView.builder(
                    itemCount: filteredHomework.length,
                    itemBuilder: (context, index) {
                      final homework = filteredHomework[index];
                      final assignedDate = DateTime.parse(homework['assigned_date']).toLocal();
                      final dueDate = DateTime.parse(homework['due_date']).toLocal();
                      final isOverdue = _isHomeworkOverdue(homework['due_date']);
                      final teacherName = '${homework['teachers']['first_name']} ${homework['teachers']['last_name']}';
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          homework['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          homework['subject'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isOverdue
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.green.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isOverdue ? 'Overdue' : 'Active',
                                      style: TextStyle(
                                        color: isOverdue ? Colors.red : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Instructions:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(homework['description']),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Assigned Date:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${assignedDate.day}/${assignedDate.month}/${assignedDate.year}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Due Date:',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                                          style: TextStyle(
                                            color: isOverdue ? Colors.red : null,
                                            fontWeight: isOverdue ? FontWeight.bold : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Assigned by: $teacherName',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Open submission dialog
                                },
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Submit Homework'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isOverdue ? Colors.orange : Colors.green,
                                  foregroundColor: Colors.white,
                                ),
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
}
