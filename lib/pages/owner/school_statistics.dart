import 'package:flutter/material.dart';
import '/main.dart';
import '/utils/constants.dart';

class SchoolStatisticsPage extends StatefulWidget {
  const SchoolStatisticsPage({super.key});

  @override
  State<SchoolStatisticsPage> createState() => _SchoolStatisticsPageState();
}

class _SchoolStatisticsPageState extends State<SchoolStatisticsPage> {
  bool _isLoading = true;
  Map<String, int> _studentsByClass = {};
  Map<String, int> _teachersBySubject = {};
  int _totalStudents = 0;
  int _totalTeachers = 0;
  
  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }
  
  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Get students count by class
      final studentsByClassResponse = await supabase
          .from('students')
          .select('grade')
          .eq('school_id', userId);
      
      final studentsByClass = <String, int>{};
      for (final student in studentsByClassResponse) {
        final grade = student['grade'] as String;
        studentsByClass[grade] = (studentsByClass[grade] ?? 0) + 1;
      }
      
      // Get teachers and count by subject
      final teachersResponse = await supabase
          .from('teachers')
          .select('subjects')
          .eq('school_id', userId);
      
      final teachersBySubject = <String, int>{};
      for (final teacher in teachersResponse) {
        final subjects = (teacher['subjects'] as String).split(',');
        for (final subject in subjects) {
          final trimmedSubject = subject.trim();
          teachersBySubject[trimmedSubject] = (teachersBySubject[trimmedSubject] ?? 0) + 1;
        }
      }
      
      setState(() {
        _studentsByClass = Map.fromEntries(
          studentsByClass.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key))
        );
        _teachersBySubject = Map.fromEntries(
          teachersBySubject.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key))
        );
        _totalStudents = studentsByClassResponse.length;
        _totalTeachers = teachersResponse.length;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load statistics: $error', isError: true);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
            'School Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.people, size: 48, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text(
                          'Total Students',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$_totalStudents',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 48, color: Colors.green),
                        const SizedBox(height: 8),
                        const Text(
                          'Total Teachers',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$_totalTeachers',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.class_, size: 48, color: Colors.orange),
                        const SizedBox(height: 8),
                        const Text(
                          'Total Classes',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${_studentsByClass.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Students by Class
          Text(
            'Students by Class',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _studentsByClass.isEmpty
              ? const Center(
                  child: Text('No students data available'),
                )
              : SizedBox(
                  height: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: _studentsByClass.length,
                        itemBuilder: (context, index) {
                          final entry = _studentsByClass.entries.elementAt(index);
                          final percentage = (entry.value / _totalStudents) * 100;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Class ${entry.key}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${entry.value} students (${percentage.toStringAsFixed(1)}%)',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: entry.value / _totalStudents,
                                minHeight: 10,
                                backgroundColor: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
          
          const SizedBox(height: 24),
          
          // Teachers by Subject
          Text(
            'Teachers by Subject',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _teachersBySubject.isEmpty
              ? const Center(
                  child: Text('No teachers data available'),
                )
              : Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: _teachersBySubject.length,
                        itemBuilder: (context, index) {
                          final entry = _teachersBySubject.entries.elementAt(index);
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.primaries[index % Colors.primaries.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 3,
                                  child: Text(entry.key),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${entry.value} teachers',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
