import 'package:expensemate/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final user = await DatabaseHelper().loginUser(_email, _password);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id!);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarısız')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-posta'),
                validator: (val) => val == null || val.isEmpty ? 'Boş bırakılamaz' : null,
                onSaved: (val) => _email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (val) => val == null || val.isEmpty ? 'Boş bırakılamaz' : null,
                onSaved: (val) => _password = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Giriş Yap'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('Hesabın yok mu? Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}