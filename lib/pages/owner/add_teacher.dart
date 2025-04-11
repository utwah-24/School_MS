import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _subjectsController = TextEditingController();

  String? _selectedGender;
  DateTime? _joiningDate;
  bool _isLoading = false;
  String _schoolName = '';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    // _loadSchoolInfo();
    _joiningDate = DateTime.now(); // Default to today
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _qualificationController.dispose();
    _subjectsController.dispose();
    super.dispose();
  }

  // Future<void> _loadSchoolInfo() async {
  //   try {
  //     final userId = supabase.auth.currentUser!.id;
  //     final schoolData = await supabase
  //         .from('schools')
  //         .select('school_name')
  //         .eq('id', userId)
  //         .single();

  //     setState(() {
  //       _schoolName = schoolData['school_name'] ?? '';
  //     });
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Failed to load school information', isError: true);
  //     }
  //   }
  // }

  // Future<void> _selectJoiningDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _joiningDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );

  //   if (picked != null && picked != _joiningDate) {
  //     setState(() {
  //       _joiningDate = picked;
  //     });
  //   }
  // }

  // Future<void> _addTeacher() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_selectedGender == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select gender')),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     final schoolId = supabase.auth.currentUser!.id;

  //     // Get the next teacher number
  //     final countResult = await supabase
  //         .from('teachers')
  //         .select('id', count: CountOption.exact())
  //         .eq('school_id', schoolId);

  //     final teacherCount = countResult.count ?? 0;
  //     final nextTeacherNumber = teacherCount + 1;

  //     // Generate a teacher ID with the school name
  //     final teacherUserName = 'teacher${nextTeacherNumber.toString().padLeft(5, '0')}@${_schoolName.toLowerCase().replaceAll(' ', '_')}';
  //     final defaultPassword = 'Teacher123';

  //     // Create auth user for teacher
  //     final authResponse = await supabase.auth.admin.createUser(
  //       AdminUserAttributes(
  //         email: _emailController.text.trim(),
  //         password: defaultPassword,
  //         emailConfirm: _emailController.text.trim(),
  //         userMetadata: {
  //           'role': UserRoles.teacher,
  //           'school_id': schoolId,
  //           'username': teacherUserName,
  //         },
  //       ),
  //     );

  //     final userId = authResponse.user.id;

  //     // Add teacher to database
  //     await supabase.from('teachers').insert({
  //       'id': userId,
  //       'school_id': schoolId,
  //       'first_name': _firstNameController.text.trim(),
  //       'last_name': _lastNameController.text.trim(),
  //       'email': _emailController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'address': _addressController.text.trim(),
  //       'gender': _selectedGender,
  //       'qualification': _qualificationController.text.trim(),
  //       'subjects': _subjectsController.text.trim(),
  //       'joining_date': _joiningDate!.toIso8601String(),
  //       'username': teacherUserName,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });

  //     if (mounted) {
  //       context.showSnackBar('Teacher added successfully! Username: $teacherUserName');
  //       _formKey.currentState!.reset();
  //       setState(() {
  //         _selectedGender = null;
  //         _joiningDate = DateTime.now();
  //       });
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Failed to add teacher: $error', isError: true);
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Teacher',
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
                    // Personal Information Section
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedGender,
                            items:
                                _genders.map((gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            // onTap: () => _selectJoiningDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Joining Date',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _joiningDate == null
                                    ? 'Select Date'
                                    : '${_joiningDate!.day}/${_joiningDate!.month}/${_joiningDate!.year}',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 32),

                    // Contact Information Section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email address';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Professional Information Section
                    const Text(
                      'Professional Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qualificationController,
                      decoration: const InputDecoration(
                        labelText: 'Qualification',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter qualification';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectsController,
                      decoration: const InputDecoration(
                        labelText: 'Subjects Taught',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Mathematics, Physics, Chemistry',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter subjects taught';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        // onPressed: _isLoading ? null : _addTeacher,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Add Teacher',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Note: A default password will be generated and the teacher will be prompted to change it on first login.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
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
