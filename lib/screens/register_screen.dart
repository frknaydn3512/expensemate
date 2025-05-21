import 'package:expensemate/services/database_helper.dart';
import 'package:expensemate/services/debug_db_button.dart';
import 'package:expensemate/models/user_model.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final user = User(email: _email, password: _password);
      await DatabaseHelper().registerUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı!')),
      );
      Navigator.pop(context);
    } catch (e) {
      String message = 'Kayıt başarısız!';
      if (e.toString().contains('UNIQUE constraint failed')) {
        message = 'Bu e-posta zaten kayıtlı.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
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
                onPressed: _register,
                child: const Text('Kayıt Ol'),
              ),
              DebugDatabaseButton()

            ],
          ),
        ),
      ),
    );
  }
}
