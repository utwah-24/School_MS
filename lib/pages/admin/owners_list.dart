import 'package:flutter/material.dart';
import '/main.dart';
import '/utils/constants.dart';
import '/widgets/reset_password_dialog.dart';

class OwnersListPage extends StatefulWidget {
  const OwnersListPage({super.key});

  @override
  State<OwnersListPage> createState() => _OwnersListPageState();
}

class _OwnersListPageState extends State<OwnersListPage> {
  final _searchController = TextEditingController();
  bool _isLoading = true;
  List<Map<String, dynamic>> _schoolOwners = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSchoolOwners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSchoolOwners() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await supabase
          .from('schools')
          .select()
          .order('school_name', ascending: true);
      
      setState(() {
        _schoolOwners = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load school owners: $error';
        _isLoading = false;
      });
    }
  }

  void _filterSchoolOwners(String query) {
    // Implementation for filtering schools by name/email
  }

  Future<void> _resetPassword(String ownerId, String ownerEmail) async {
    try {
      await showDialog(
        context: context,
        builder: (context) => ResetPasswordDialog(userId: ownerId, email: ownerEmail),
      );
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Failed to reset password: $error', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School Owners',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by school name or email',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterSchoolOwners('');
                },
              ),
            ),
            onChanged: _filterSchoolOwners,
          ),
          
          const SizedBox(height: 16),
          
          // Statistics row
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 32, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text('Total Schools'),
                        Text(
                          '${_schoolOwners.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                        const Icon(Icons.verified_user, size: 32, color: Colors.green),
                        const SizedBox(height: 8),
                        const Text('Active Schools'),
                        Text(
                          '${_schoolOwners.where((owner) => owner['is_active'] == true).length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Schools list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: _loadSchoolOwners,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : _schoolOwners.isEmpty
                        ? const Center(
                            child: Text('No school owners found'),
                          )
                        : ListView.builder(
                            itemCount: _schoolOwners.length,
                            itemBuilder: (context, index) {
                              final owner = _schoolOwners[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      owner['school_name'][0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(owner['school_name']),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Owner: ${owner['owner_name']}'),
                                      Text('Email: ${owner['email']}'),
                                    ],
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'view',
                                        child: Row(
                                          children: [
                                            Icon(Icons.visibility),
                                            SizedBox(width: 8),
                                            Text('View Details'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'reset',
                                        child: Row(
                                          children: [
                                            Icon(Icons.key),
                                            SizedBox(width: 8),
                                            Text('Reset Password'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'deactivate',
                                        child: Row(
                                          children: [
                                            Icon(Icons.block),
                                            SizedBox(width: 8),
                                            Text('Deactivate'),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'reset') {
                                        _resetPassword(owner['id'], owner['email']);
                                      }
                                    },
                                  ),
                                  isThreeLine: true,
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
