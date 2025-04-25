import 'package:flutter/material.dart';
import 'package:flutter_practical_20/ui/auth_ui/login_screen.dart';
import 'package:flutter_practical_20/ui/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}