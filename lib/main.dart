import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Імпортуємо ваш екран авторизації

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borrowed Items Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4FA0)),
        useMaterial3: true,
      ),
      // Робимо стартовим екраном ваш екран авторизації
      home: const LoginScreen(),
    );
  }
}