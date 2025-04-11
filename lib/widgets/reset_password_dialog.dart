import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';


// import '/utils/constants.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String userId;
  final String email;

  const ResetPasswordDialog({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Future<void> _resetPassword() async {
  //   if (_passwordController.text.isEmpty) {
  //     context.showSnackBar('Please enter a password', isError: true);
  //     return;
  //   }

  //   if (_passwordController.text != _confirmPasswordController.text) {
  //     context.showSnackBar('Passwords do not match', isError: true);
  //     return;
  //   }

  //   if (_passwordController.text.length < 6) {
  //     context.showSnackBar('Password must be at least 6 characters', isError: true);
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     await supabase.auth.admin.updateUserById(
  //       widget.userId,
  //       UserAttributes(
  //         password: _passwordController.text,
  //       ), attributes: null,
  //     );

  //     if (mounted) {
  //       Navigator.of(context).pop();
  //       context.showSnackBar('Password reset successfully');
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       context.showSnackBar('Failed to reset password: $error', isError: true);
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
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reset password for: ${widget.email}'),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
            ),
            obscureText: !_showPassword,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
            ),
            obscureText: !_showPassword,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Reset Password'),
        ),
      ],
    );
  }
}
