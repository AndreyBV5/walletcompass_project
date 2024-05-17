import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/credit_card.dart';
import 'package:copia_walletfirebase/model/expense.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/my_list_tile.dart';
import 'package:flutter/material.dart';

class ExpenseControl extends StatefulWidget {
  final String cardId;

  const ExpenseControl({super.key, required this.cardId});

  @override
  State<ExpenseControl> createState() => _ExpenseControlState();
}

class _ExpenseControlState extends State<ExpenseControl> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNewExpenseBox,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // StreamBuilder para la tarjeta de crédito
          // Dentro del StreamBuilder para la tarjeta de crédito en ExpenseControl
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('TarjetaCredito')
                .doc(widget
                    .cardId) // Filtrar por el ID de la tarjeta seleccionada
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              var cardData = snapshot.data
                  .data(); // Obtener los datos de la tarjeta de crédito
              return Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                          height:
                              90), // Espacio en blanco para separar la tarjeta de la lista de gastos
                      CreditCard(
                        cardNumber: cardData['numeroTarjeta'],
                        cardHolderName: cardData['nombreTitular'],
                        expiryDate: cardData['fechaVencimiento'],
                        cardBackgroundImageUrl:
                            'https://cdn.mos.cms.futurecdn.net/DoZSMXF87kCuzbymsuEFHo.jpg',
                        logoAssetPath: 'assets/images/Mastercard-Logo.png',
                        onDelete: () {},
                        isButtonVisible: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                  Positioned(
                    top: 45, // Ajuste del margen superior
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Gastos')
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            double totalAmount = 0;
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              totalAmount += snapshot.data.docs[i]['monto'];
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
              );
            },
          ),

          // Lista de gastos
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Gastos').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    Expense expense = Expense.fromDocument(doc);
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 131, 117, 117)
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 25),
                      child: MyListTile(
                        title: expense.name,
                        trailing: expense.amount.toString(),
                        onEdithPressed: (context) => openEditBox(expense),
                        onDeletePressed: (context) => openDeleteBox(expense),
                      ),
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
            'cardId': widget.cardId, // Añadir cardId aquí
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
            'cardId': widget.cardId, // Añadir cardId aquí
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
