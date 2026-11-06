import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../data/repositories/auth_repository.dart';
import 'login_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _auth = AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _auth.sendPasswordReset(_email.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('If this email is registered, a reset link was sent')),
      );
      Navigator.pop(context);
    } on AuthFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF7A7A7A)),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Confirm',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'By continuing, you agree to keep your lending history accurate and private.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}