import 'package:flutter/material.dart';
import '../core/widgets/auth_header.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/secondary_button.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const AuthHeader(),
              const SizedBox(height: 32),

              // Поле Email
              const CustomTextField(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
              const SizedBox(height: 16),

              // Поле Password
              const CustomTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                suffixIcon: Icon(Icons.close),
              ),
              const SizedBox(height: 8),

              // Поле Password
              const CustomTextField(
                labelText: 'Password',
                hintText: 'Enter your password again',
                obscureText: true,
                suffixIcon: Icon(Icons.close),
              ),
              const SizedBox(height: 8),

              // Кнопка Sign up
              PrimaryButton(
                text: 'Sign up',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Кнопка Log in
              SecondaryButton(
                text: 'Log in',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Нижній текст узгодження
              const Text(
                'By continuing, you agree to keep your lending history accurate and private.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}