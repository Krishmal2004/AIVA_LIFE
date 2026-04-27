import 'package:aiva_life/screens/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:aiva_life/landingPage.dart';
import 'package:aiva_life/screens/navigation-instruction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIVA Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00D4FF)),
        useMaterial3: true,
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/onboarding': (context) => const NavigationInstructionPage(),
        '/': (context) => const UserDashboard(),
      }
    );
  }
}
