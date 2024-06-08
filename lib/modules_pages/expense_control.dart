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
  final Map<String, dynamic> cardData;
  final String nameCard;
  final String documentId;

  const ExpenseControl(
      {super.key,
      required this.cardData,
      required this.nameCard,
      required this.documentId});

  @override
  State<ExpenseControl> createState() =>
      _ExpenseControlState(cardData, nameCard, documentId);
}

class _ExpenseControlState extends State<ExpenseControl> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final Map<String, dynamic> cardData;
  final String nameCard;
  final String documentId;

  _ExpenseControlState(this.cardData, this.nameCard, this.documentId);

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
                    cardNumber: cardData['numeroTarjeta'].toString(),
                    cardHolderName: cardData['nombreTitular'].toString(),
                    expiryDate: cardData['fechaExpiracion'].toString(),
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
                          .where('cardId',
                              isEqualTo: cardData[
                                  'id']) // Asegúrate de tener un campo 'id' en cardData
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
              child: Center(
            child: Text(
                "Mostrar Datos de Gastos" + cardData.toString() + nameCard),
          )),
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
          Map<String, dynamic> gastoData = {
            'nombre': nameController.text,
            'monto': double.parse(amountController.text),
            'fecha': DateTime.now(),
          };

          // Obtener la referencia a la colección 'PerfilPrueba'
          CollectionReference perfilPruebaCollection =
              FirebaseFirestore.instance.collection('PerfilPrueba');

          // Actualizar el campo 'gastos' dentro de la tarjeta
          perfilPruebaCollection.doc(documentId).update({
            'TarjetasCredito.$nameCard.Gastos':
                FieldValue.arrayUnion([gastoData])
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
            'cardId': cardData['id'], // Usa el cardId correcto
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
