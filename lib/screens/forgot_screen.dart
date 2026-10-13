import 'package:flutter/material.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import 'login_screen.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC), // Світлий фон з дизайну
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Підзаголовок
              const Text(
                'Enter your email address.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                ),
              ),
              const SizedBox(height: 32),

              // Поле Email
              const CustomTextField(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
              const SizedBox(height: 16),

              // Кнопка Confirm
              PrimaryButton(
                text: 'Confirm',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

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