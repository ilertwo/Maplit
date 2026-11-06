import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/auth_header.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/secondary_button.dart';
import '../data/repositories/auth_repository.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _auth = AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _auth.signUp(
        email: _email.text,
        password: _password.text,
        displayName: _name.text,
      );
      await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'email');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'home'),
          builder: (_) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on AuthFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _clearButton(TextEditingController c) => IconButton(
    icon: const Icon(Icons.cancel_outlined, color: Colors.black54),
    onPressed: _isLoading ? null : () => c.clear(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(),
                const SizedBox(height: 32),

                // Name
                CustomTextField(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  controller: _name,
                  enabled: !_isLoading,
                  validator: (v) => Validators.required(v, 'Name'),
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password
                CustomTextField(
                  labelText: 'Password',
                  hintText: 'At least 6 characters',
                  obscureText: true,
                  controller: _password,
                  enabled: !_isLoading,
                  validator: Validators.password,
                  suffixIcon: _clearButton(_password),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                CustomTextField(
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password again',
                  obscureText: true,
                  controller: _confirm,
                  enabled: !_isLoading,
                  validator: Validators.confirm(() => _password.text),
                  suffixIcon: _clearButton(_confirm),
                ),
                const SizedBox(height: 24),

                // Sign up
                PrimaryButton(
                  text: 'Sign up',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),

                // Log in
                SecondaryButton(
                  text: 'Log in',
                  onPressed: _isLoading ? () {} : () => Navigator.pop(context),
                ),
                const SizedBox(height: 32),

                const Text(
                  'By continuing, you agree to keep your lending history accurate and private.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}