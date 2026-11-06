import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/auth_header.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/secondary_button.dart';
import '../data/repositories/auth_repository.dart';
import 'forgot_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _auth.signIn(email: _email.text, password: _password.text);
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'email');
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signed in')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: 'home'),
            builder: (_) => const HomeScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHeader(),
                    const SizedBox(height: 32),
                    CustomTextField(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                      controller: _password,
                      validator: Validators.password,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotScreen()),
                        ),
                        child: const Text('Forgot password?',
                            style: TextStyle(color: Color(0xFF6B4FA0))),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Log in',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _submit,
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      text: 'Sign up',
                      onPressed: _isLoading
                          ? () {}
                          : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      ),
                    ),
                    const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}