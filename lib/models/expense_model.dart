class Expense {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}
