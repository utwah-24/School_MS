import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/main.dart';
import '/utils/constants.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _gradeController = TextEditingController();
  final _rollNumberController = TextEditingController();

  String? _selectedGender;
  DateTime? _dateOfBirth;
  bool _isLoading = false;
  String _schoolName = '';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadSchoolInfo();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _gradeController.dispose();
    _rollNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadSchoolInfo() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final schoolData =
          await supabase
              .from('schools')
              .select('school_name')
              .eq('id', userId)
              .single();

      setState(() {
        _schoolName = schoolData['school_name'] ?? '';
      });
    } catch (error) {
      if (mounted) {
        context.showSnackBar(
          'Failed to load school information',
          isError: true,
        );
      }
    }
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(DateTime.now().year - 10),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  // Future<void> _addStudent() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_dateOfBirth == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please select date of birth')),
  //     );
  //     return;
  //   }
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

  //     // Get the next student number
  //     final countResult = await supabase
  //         .from('students')
  //         .select('id', count: CountOption.exact())
  //         .eq('school_id', schoolId);

  //     final studentCount = countResult.count ?? 0;
  //     final nextStudentNumber = studentCount + 1;

  //     // Generate a student ID with the school name
  //     final studentUserName = 'student${nextStudentNumber.toString().padLeft(5, '0')}@${_schoolName.toLowerCase().replaceAll(' ', '_')}';
  //     final defaultPassword = 'Student123';

  //     // Create auth user for student
  //     final authResponse = await supabase.auth.admin.createUser(
  //       AdminUserAttributes(
  //         email: _emailController.text.isNotEmpty
  //             ? _emailController.text.trim()
  //             : '$studentUserName@school.com',
  //         password: defaultPassword,
  //         userMetadata: {
  //           'role': UserRoles.student,
  //           'school_id': schoolId,
  //           'username': studentUserName,
  //         },
  //       ),
  //     );

  //     final userId = authResponse.user.id;

  //     // Add student to database
  //     await supabase.from('students').insert({
  //       'id': userId,
  //       'school_id': schoolId,
  //       'first_name': _firstNameController.text.trim(),
  //       'last_name': _lastNameController.text.trim(),
  //       'email': _emailController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'address': _addressController.text.trim(),
  //       'gender': _selectedGender,
  //       'date_of_birth': _dateOfBirth!.toIso8601String(),
  //       'grade': _gradeController.text.trim(),
  //       'roll_number': _rollNumberController.text.trim(),
  //       'username': studentUserName,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });

  //     if (mounted) {
  //       context.showSnackBar('Student added successfully! Username: $studentUserName');
  //       _formKey.currentState!.reset();
  //       setState(() {
  //         _selectedGender = null;
  //         _dateOfBirth = null;
  //       });
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Failed to add student: $error', isError: true);
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
            'Add New Student',
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
                            onTap: () => _selectDateOfBirth(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _dateOfBirth == null
                                    ? 'Select Date'
                                    : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
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
                        labelText: 'Email Address (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 32),

                    // Academic Information Section
                    const Text(
                      'Academic Information',
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
                            controller: _gradeController,
                            decoration: const InputDecoration(
                              labelText: 'Grade/Class',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter grade/class';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _rollNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Roll Number (Optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        // onPressed: _isLoading ? null : _addStudent,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Add Student',
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Note: A default password will be generated and the student will be prompted to change it on first login.',
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
