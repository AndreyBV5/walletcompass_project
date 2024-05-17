import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String name;
  final double amount;
  final DateTime date;

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory Expense.fromDocument(DocumentSnapshot doc) {
    return Expense(
      id: doc.id,
      name: doc['nombre'],
      amount: (doc['monto'] as num).toDouble(),
      date: (doc['fecha'] as Timestamp).toDate(),
    );
  }
}
