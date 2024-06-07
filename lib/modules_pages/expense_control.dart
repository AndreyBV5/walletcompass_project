import 'package:copia_walletfirebase/model/credit_card.dart';
import 'package:copia_walletfirebase/model/expense.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomFabLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    const double fabHeightOffset = 40.0;
    final double fabX = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        16.0;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        fabHeightOffset;
    return Offset(fabX, fabY);
  }
}

class ExpenseControl extends StatefulWidget {
  final Map<String, dynamic> cardId;

  const ExpenseControl({super.key, required this.cardId});

  @override
  State<ExpenseControl> createState() => _ExpenseControlState(cardId);
}

class _ExpenseControlState extends State<ExpenseControl> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
 final Map<String, dynamic> cardId;

_ExpenseControlState( this.cardId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: CustomFabLocation(),
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 110),
                      CreditCard(
                        cardNumber: cardId['numeroTarjeta'].toString(),
                        cardHolderName: cardId['nombreTitular'].toString(),
                        expiryDate: cardId['fechaExpiracion'].toString(),
                        cardBackgroundImageUrl:
                            'https://cdn.mos.cms.futurecdn.net/DoZSMXF87kCuzbymsuEFHo.jpg',
                        logoAssetPath: 'assets/images/Mastercard-Logo.png',
                        onLongPress: null,
                        onTap: () {},
                      ),
                    ],
                  ),
                  Positioned(
                    top: 65,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Gastos')
                              .where('cardId', isEqualTo: widget.cardId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            double totalAmount = 0;
                            for (var doc in snapshot.data!.docs) {
                              totalAmount += doc['monto'];
                            }
                            return Text(
                              'Total: \$${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const Text(
                          'CR',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Gastos')
                  .where('cardId', isEqualTo: widget.cardId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    Expense expense = Expense.fromDocument(doc);
                    return MyListTile(
                      title: expense.name,
                      trailing: expense.amount.toString(),
                      onEdithPressed: (context) => openEditBox(expense),
                      onDeletePressed: (context) => openDeleteBox(expense),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Nombre"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: "Gasto"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _createNewExpenseButton(),
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Nombre"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: "Gasto"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          _cancelButton(),
          _editExpenseButton(expense),
        ],
      ),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Borrar gasto?"),
        actions: [
          _cancelButton(),
          _deleteExpenseButton(expense.id),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancelar'),
    );
  }

  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          FirebaseFirestore.instance.collection('Gastos').add({
            'nombre': nameController.text,
            'monto': double.parse(amountController.text),
            'fecha': DateTime.now(),
            'cardId': widget.cardId,
          });
          Navigator.pop(context);
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Aceptar'),
    );
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          FirebaseFirestore.instance
              .collection('Gastos')
              .doc(expense.id)
              .update({
            'nombre': nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            'monto': amountController.text.isNotEmpty
                ? double.parse(amountController.text)
                : expense.amount,
            'fecha': DateTime.now(),
            'cardId': widget.cardId,
          });
          Navigator.pop(context);
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Guardar"),
    );
  }

  Widget _deleteExpenseButton(String id) {
    return MaterialButton(
      onPressed: () {
        FirebaseFirestore.instance.collection('Gastos').doc(id).delete();
        Navigator.pop(context);
      },
      child: const Text('Borrar'),
    );
  }
}
