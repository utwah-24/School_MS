import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class AssignHomeworkPage extends StatefulWidget {
  const AssignHomeworkPage({super.key});

  @override
  State<AssignHomeworkPage> createState() => _AssignHomeworkPageState();
}

class _AssignHomeworkPageState extends State<AssignHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedClass;
  String? _selectedSubject;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  List<String> _classes = [];
  List<String> _subjects = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  String _schoolId = '';
  
  @override
  void initState() {
    super.initState();
    _loadTeacherData();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTeacherData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Get teacher data
      final teacherData = await supabase
          .from('teachers')
          .select('school_id, subjects')
          .eq('id', userId)
          .single();
      
      _schoolId = teacherData['school_id'] as String;
      
      // Split subjects string into list
      final subjectsString = teacherData['subjects'] as String;
      _subjects = subjectsString.split(',').map((s) => s.trim()).toList();
      
      // Get classes from students table
      final classesResponse = await supabase
          .from('students')
          .select('grade')
          .eq('school_id', _schoolId)
          .order('grade', ascending: true);
      
      // Get unique classes
      final classesSet = <String>{};
      for (final student in classesResponse) {
        classesSet.add(student['grade'] as String);
      }
      _classes = classesSet.toList();
      
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showSnackBar('Failed to load data: $error', isError: true);
      }
    }
  }
  
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }
  
  Future<void> _assignHomework() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClass == null) {
      context.showSnackBar('Please select a class', isError: true);
      return;
    }
    if (_selectedSubject == null) {
      context.showSnackBar('Please select a subject', isError: true);
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final userId = supabase.auth.currentUser!.id;
      
      // Add homework to database
      await supabase.from('homework').insert({
        'teacher_id': userId,
        'school_id': _schoolId,
        'class': _selectedClass,
        'subject': _selectedSubject,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'assigned_date': DateTime.now().toIso8601String(),
        'due_date': _dueDate.toIso8601String(),
      });
      
      if (mounted) {
        context.showSnackBar('Homework assigned successfully');
        _formKey.currentState!.reset();
        setState(() {
          _selectedClass = null;
          _selectedSubject = null;
          _dueDate = DateTime.now().add(const Duration(days: 7));
        });
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Failed to assign homework: $error', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
            'Assign Homework',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            items: _classes.map((className) {
                              return DropdownMenuItem<String>(
                                value: className,
                                child: Text(className),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedClass = value;
                              });
                            },
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
                            items: _subjects.map((subject) {
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Homework Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description and Instructions',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDueDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _assignHomework,
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Assign Homework', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
