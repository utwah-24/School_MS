import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class ViewResultsPage extends StatefulWidget {
  const ViewResultsPage({super.key});

  @override
  State<ViewResultsPage> createState() => _ViewResultsPageState();
}

class _ViewResultsPageState extends State<ViewResultsPage> {
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = true;
  String? _selectedSubject;
  List<String> _subjects = [];
  Map<String, double> _subjectAverages = {};
  
  @override
  void initState() {
    super.initState();
    _loadResults();
  }
  
  Future<void> _loadResults() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Get results
      final resultsResponse = await supabase
          .from('results')
          .select('*, teachers:teacher_id(first_name, last_name)')
          .eq('student_id', userId)
          .order('date', ascending: false);
      
      final results = List<Map<String, dynamic>>.from(resultsResponse);
      
      // Extract unique subjects
      final subjectsSet = <String>{};
      for (final result in results) {
        subjectsSet.add(result['subject'] as String);
      }
      
      // Calculate averages for each subject
      final subjectAverages = <String, double>{};
      for (final subject in subjectsSet) {
        final subjectResults = results.where((r) => r['subject'] == subject).toList();
        if (subjectResults.isNotEmpty) {
          final total = subjectResults.fold<double>(
            0,
            (sum, result) => sum + (result['marks'] as num).toDouble(),
          );
          subjectAverages[subject] = total / subjectResults.length;
        }
      }
      
      setState(() {
        _results = results;
        _subjects = subjectsSet.toList()..sort();
        _subjectAverages = subjectAverages;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load results: $error', isError: true);
      }
    }
  }
  
  List<Map<String, dynamic>> _getFilteredResults() {
    if (_selectedSubject == null) {
      return _results;
    }
    return _results.where((result) => result['subject'] == _selectedSubject).toList();
  }
  
  // Helper function to get grade based on marks
  String _getGrade(double marks) {
    if (marks >= 90) return 'A+';
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B';
    if (marks >= 60) return 'C';
    if (marks >= 50) return 'D';
    return 'F';
  }
  
  // Helper function to get color based on marks
  Color _getGradeColor(double marks) {
    if (marks >= 80) return Colors.green;
    if (marks >= 70) return Colors.lightGreen;
    if (marks >= 60) return Colors.amber;
    if (marks >= 50) return Colors.orange;
    return Colors.red;
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredResults();
    
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
            'Academic Results',
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
          
          // Subject averages cards
          if (_selectedSubject == null && _subjects.isNotEmpty)
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  final average = _subjectAverages[subject] ?? 0;
                  final grade = _getGrade(average);
                  final color = _getGradeColor(average);
                  
                  return Card(
                    margin: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Average:',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${average.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grade:',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                grade,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
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
          
          const SizedBox(height: 16),
          
          // Results list
          Expanded(
            child: filteredResults.isEmpty
                ? const Center(
                    child: Text('No results found'),
                  )
                : ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];
                      final marks = (result['marks'] as num).toDouble();
                      final maxMarks = (result['max_marks'] as num).toDouble();
                      final percentage = (marks / maxMarks) * 100;
                      final grade = _getGrade(percentage);
                      final color = _getGradeColor(percentage);
                      final teacherName = '${result['teachers']['first_name']} ${result['teachers']['last_name']}';
                      final date = DateTime.parse(result['date']).toLocal();
                      final formattedDate = '${date.day}/${date.month}/${date.year}';
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                          result['subject'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '${result['exam_type']} | $formattedDate',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      grade,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: marks / maxMarks,
                                minHeight: 10,
                                backgroundColor: Colors.grey[200],
                                color: color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Marks: $marks / $maxMarks'),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              if (result['comments'] != null &&
                                  (result['comments'] as String).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Teacher\'s Comments:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(result['comments']),
                                  ],
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'Submitted by: $teacherName',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
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
