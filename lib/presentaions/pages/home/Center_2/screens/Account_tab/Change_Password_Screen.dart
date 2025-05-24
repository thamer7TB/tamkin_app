
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../core/resorces/Colors_Manager.dart';
import '../../../../../../core/resorces/Fonts_Manager.dart';
import '../../../../../../core/resorces/Size_Value_Manager.dart';
import '../../../../../../services/local_storage_service.dart';
import '../../../../../widgets/Custom_Button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tokenData = await LocalStorageService.getLoginData();
      final token = tokenData?['token'];

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        Uri.parse('https://your-api.com/api/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context).pop();
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to change password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(15),
            left: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsManager.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: ColorsManager.primaryColor,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: ColorsManager.white,
            fontWeight: FontWeight.w400,
            fontFamily: FontsManager.GEDinkum,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 24.0 : screenWidth * 0.2,
          vertical: 24.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password Field
              _buildPasswordField(
                context: context,
                label: 'Current Password',
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                onToggleVisibility: () => setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                }),
              ),
              SizedBox(height: screenHeight * 0.015),

              // New Password Field
              _buildPasswordField(
                context: context,
                label: 'New Password',
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                onToggleVisibility: () => setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                }),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Confirm New Password Field
              _buildPasswordField(
                context: context,
                label: 'Confirm New Password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () => setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.3),
              // Save Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _isLoading ? null : _submitForm,
                  buttonText: _isLoading ? '' : 'Save',
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            fontFamily: FontsManager.GEDinkum,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.02, horizontal: screenWidth * 0.032),
            filled: true,
            fillColor: ColorsManager.grayLow2,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: ColorsManager.primaryColor,
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: ColorsManager.transparent, width: 2),
              borderRadius: BorderRadius.circular(RadiusManager.rounded30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.transparent),
              borderRadius: BorderRadius.circular(RadiusManager.rounded30),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _changePassword();
    }
  }
}