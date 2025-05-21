import 'package:expensemate/screens/add_expense_screen.dart';
import 'package:expensemate/screens/home_screen.dart';
import 'package:expensemate/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getStartScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Cüzdanım',
  theme: ThemeData(primarySwatch: Colors.teal),
  routes: {
    '/addExpense': (context) => const AddExpenseScreen(), // EKLENDİ
  },
  home: FutureBuilder<Widget>(
    future: _getStartScreen(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return snapshot.data!;
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  ),
);

  }
}
