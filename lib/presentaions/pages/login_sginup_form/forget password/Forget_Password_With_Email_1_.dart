
// ForgetPasswordRP1.dart
import 'package:flutter/material.dart';
import '../../../services/forgot_password_service.dart';


class ForgetPasswordRP1 extends StatefulWidget {
  final VoidCallback onEmailVerified;
  const ForgetPasswordRP1({required this.onEmailVerified, super.key});

  @override
  State<ForgetPasswordRP1> createState() => _ForgetPasswordRP1State();
}

class _ForgetPasswordRP1State extends State<ForgetPasswordRP1> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() => _loading = true);
    final service = ForgetPasswordService();
    final success = await service.sendResetCodeToEmail(_emailController.text);
    setState(() {
      _loading = false;
      _error = success ? null : "Email not found";
    });
    if (success) widget.onEmailVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forget Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Reset Your account password and access to your account again", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                errorText: _error,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading ? CircularProgressIndicator(color: Colors.white) : const Text("Submit"),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
