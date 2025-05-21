
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DebugDatabaseButton extends StatelessWidget {
  const DebugDatabaseButton({super.key});

  Future<void> _printDatabasePath(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final fullPath = join(dbPath, 'expenses.db');

      if (await File(fullPath).exists()) {
        debugPrint('📁 Veritabanı yolu: $fullPath');

        final db = await openDatabase(fullPath);
        final users = await db.query('users');
        final expenses = await db.query('expenses');

        debugPrint('👤 Kullanıcılar:');
        for (var user in users) {
          debugPrint(user.toString());
        }

        debugPrint('💸 Harcamalar:');
        for (var expense in expenses) {
          debugPrint(expense.toString());
        }
      } else {
        debugPrint('❌ Veritabanı dosyası bulunamadı: $fullPath');
      }
    } catch (e) {
      debugPrint('⚠️ Veritabanı görüntüleme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _printDatabasePath(context),
      child: const Text('Veritabanını Terminalde Göster'),
    );
  }
}
