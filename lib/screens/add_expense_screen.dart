import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';
import '../services/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expenseToEdit; // <-- düzenleme için eklendi

  const AddExpenseScreen({Key? key, this.expenseToEdit}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = 'Gıda';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expenseToEdit != null) {
      _title = widget.expenseToEdit!.title;
      _category = widget.expenseToEdit!.category;
      _amount = widget.expenseToEdit!.amount;
      _selectedDate = widget.expenseToEdit!.date;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    _formKey.currentState?.save();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final expense = Expense(
      id: widget.expenseToEdit?.id,
      userId: userId,
      title: _title,
      amount: _amount,
      category: _category,
      date: _selectedDate,
    );

    if (widget.expenseToEdit == null) {
      await DatabaseHelper().insertExpense(expense);
    } else {
      await DatabaseHelper().updateExpense(expense); // Güncelleme fonksiyonu
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.expenseToEdit == null ? 'Harcama Ekle' : 'Harcamayı Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                onSaved: (val) => _title = val!,
              ),
              TextFormField(
                initialValue: _amount != 0 ? _amount.toString() : '',
                decoration: const InputDecoration(labelText: 'Tutar (₺)'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _amount = double.tryParse(val ?? '') ?? 0,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: ['Gıda', 'Ulaşım', 'Eğlence', 'Fatura', 'Diğer']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() {
                  _category = val!;
                }),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.expenseToEdit == null ? 'Kaydet' : 'Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
