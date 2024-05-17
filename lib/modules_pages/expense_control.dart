import 'package:flutter/material.dart';

class ExpenseControl extends StatefulWidget {
  final String cardId;

  const ExpenseControl({super.key, required this.cardId});

  @override
  State<ExpenseControl> createState() => _ExpenseControlState();
}

class _ExpenseControlState extends State<ExpenseControl> {
  //Abrir nuevo expense box
  void openNewExpenseBox() {
    showDialog(
        context: context,
        builder: (contex) => AlertDialog(
              title: Text("Nuevo gasto"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
