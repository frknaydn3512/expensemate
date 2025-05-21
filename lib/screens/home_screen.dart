import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expensemate/services/database_helper.dart';
import 'package:expensemate/models/expense_model.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final data = await DatabaseHelper().getAllExpenses();
    setState(() {
      expenses = data;
    });
  }

  double get total => expenses.fold(0, (sum, item) => sum + item.amount);

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text('Cüzdanım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Toplam: ₺${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final exp = expenses[index];
                return ListTile(
                  title: Text(exp.title),
                  subtitle: Text('${exp.category} - ${DateFormat.yMMMd().format(exp.date)}'),
                  trailing: Text('₺${exp.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/addExpense');
          _loadExpenses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
