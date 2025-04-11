import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class UploadResultsPage extends StatefulWidget {
  const UploadResultsPage({super.key});

  @override
  State<UploadResultsPage> createState() => _UploadResultsPageState();
}

class _UploadResultsPageState extends State<UploadResultsPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedExamType;
  List<String> _classes = [];
  List<String> _subjects = [];
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;
  bool _isLoadingStudents = false;
  String _schoolId = '';

  final List<String> _examTypes = [
    'Mid-Term',
    'Final Exam',
    'Quiz',
    'Assignment',
    'Project',
  ];

  final Map<String, List<TextEditingController>> _marksControllers = {};

  @override
  void initState() {
    super.initState();
    // _loadTeacherData();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controllers in _marksControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  // Future<void> _loadTeacherData() async {
  //   try {
  //     final userId = supabase.auth.currentUser!.id;

  //     // Get teacher data
  //     final teacherData = await supabase
  //         .from('teachers')
  //         .select('school_id, subjects')
  //         .eq('id', userId)
  //         .single();

  //     _schoolId = teacherData['school_id'] as String;

  //     // Split subjects string into list
  //     final subjectsString = teacherData['subjects'] as String;
  //     _subjects = subjectsString.split(',').map((s) => s.trim()).toList();

  //     // Get classes from students table
  //     final classesResponse = await supabase
  //         .from('students')
  //         .select('grade')
  //         .eq('school_id', _schoolId)
  //         .order('grade', ascending: true);

  //     // Get unique classes
  //     final classesSet = <String>{};
  //     for (final student in classesResponse) {
  //       classesSet.add(student['grade'] as String);
  //     }
  //     _classes = classesSet.toList();

  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (mounted) {
  //       context.showSnackBar('Failed to load data: $error', isError: true);
  //     }
  //   }
  // }

  // Future<void> _loadStudents() async {
  //   if (_selectedClass == null) return;

  //   setState(() {
  //     _isLoadingStudents = true;
  //     _students = [];
  //     _marksControllers.clear();
  //   });

  //   try {
  //     final studentsResponse = await supabase
  //         .from('students')
  //         .select()
  //         .eq('school_id', _schoolId)
  //         .eq('grade', _selectedClass)
  //         .order('last_name', ascending: true);

  //     final students = List<Map<String, dynamic>>.from(studentsResponse);

  //     // Create controllers for each student
  //     for (final student in students) {
  //       final studentId = student['id'] as String;
  //       _marksControllers[studentId] = [
  //         TextEditingController(), // Marks
  //         TextEditingController(), // Comments
  //       ];
  //     }

  //     setState(() {
  //       _students = students;
  //       _isLoadingStudents = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       _isLoadingStudents = false;
  //     });
  //     if (mounted) {
  //       context.showSnackBar('Failed to load students: $error', isError: true);
  //     }
  //   }
  // }

  // Future<void> _uploadResults() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_selectedClass == null || _selectedSubject == null || _selectedExamType == null) {
  //     context.showSnackBar('Please select class, subject and exam type', isError: true);
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final userId = supabase.auth.currentUser!.id;
  //     final results = [];

  //     // Prepare results data
  //     for (final student in _students) {
  //       final studentId = student['id'] as String;
  //       final controllers = _marksControllers[studentId]!;
  //       final marks = controllers[0].text;
  //       final comments = controllers[1].text;

  //       if (marks.isNotEmpty) {
  //         results.add({
  //           'student_id': studentId,
  //           'teacher_id': userId,
  //           'school_id': _schoolId,
  //           'class': _selectedClass,
  //           'subject': _selectedSubject,
  //           'exam_type': _selectedExamType,
  //           'marks': double.parse(marks),
  //           'max_marks': 100,
  //           'comments': comments,
  //           'date': DateTime.now().toIso8601String(),
  //         });
  //       }
  //     }

  //     if (results.isEmpty) {
  //       context.showSnackBar('No marks entered', isError: true);
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return;
  //     }

  //     // Insert results
  //     await supabase.from('results').insert(results);

  //     if (mounted) {
  //       context.showSnackBar('Results uploaded successfully');
  //       _formKey.currentState!.reset();
  //       setState(() {
  //         _selectedClass = null;
  //         _selectedSubject = null;
  //         _selectedExamType = null;
  //         _students = [];
  //         _marksControllers.clear();
  //       });
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Failed to upload results: $error', isError: true);
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Student Results',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Class',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedClass,
                        items:
                            _classes.map((className) {
                              return DropdownMenuItem<String>(
                                value: className,
                                child: Text(className),
                              );
                            }).toList(),
                        onChanged: null,
                        // onChanged: (value) {
                        //   setState(() {
                        //     _selectedClass = value;
                        //   });
                        //   _loadStudents();
                        // },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedSubject,
                        items:
                            _subjects.map((subject) {
                              return DropdownMenuItem<String>(
                                value: subject,
                                child: Text(subject),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubject = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Exam Type',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedExamType,
                        items:
                            _examTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExamType = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (_isLoadingStudents)
            const Center(child: CircularProgressIndicator())
          else if (_students.isEmpty && _selectedClass != null)
            const Center(child: Text('No students found in this class'))
          else if (_students.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Students in $_selectedClass',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        final studentId = student['id'] as String;
                        final controllers = _marksControllers[studentId]!;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${student['first_name']} ${student['last_name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Username: ${student['username']}'),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: controllers[0],
                                        decoration: const InputDecoration(
                                          labelText: 'Marks (out of 100)',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            final marks = double.tryParse(
                                              value,
                                            );
                                            if (marks == null) {
                                              return 'Enter valid marks';
                                            }
                                            if (marks < 0 || marks > 100) {
                                              return 'Marks must be between 0-100';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        controller: controllers[1],
                                        decoration: const InputDecoration(
                                          labelText: 'Comments (Optional)',
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 1,
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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      // onPressed: _isLoading ? null : _uploadResults,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Upload Results',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
