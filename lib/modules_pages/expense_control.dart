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
      backgroundColor: Colors.white,
      floatingActionButtonLocation: CustomFabLocation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: openNewExpenseBox,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
                    logoAssetPath:
                        getCardLogo(cardData['numeroTarjeta'].toString()),
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
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('PerfilPrueba')
                          .doc(documentId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 0,
                          );
                        }

                        var data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (data == null) {
                          return const Center(
                              child: Text(
                                  'No hay datos disponibles. Agregue un gasto.'));
                        }

                        var tarjetasCredito =
                            data['TarjetasCredito'] as Map<String, dynamic>?;
                        var tarjeta =
                            tarjetasCredito?[nameCard] as Map<String, dynamic>?;
                        var gastos = tarjeta?['Gastos'] as List<dynamic>? ?? [];

                        double totalAmount = 0;
                        for (var gasto in gastos) {
                          totalAmount += gasto['monto'];
                        }

                        return Text(
                          'Total: ₡${totalAmount.toStringAsFixed(2)}',
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
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('PerfilPrueba')
                  .doc(documentId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                var data = snapshot.data!.data() as Map<String, dynamic>?;
                if (data == null) {
                  return const Center(child: Text('No data available'));
                }

                var tarjetasCredito =
                    data['TarjetasCredito'] as Map<String, dynamic>?;
                var tarjeta =
                    tarjetasCredito?[nameCard] as Map<String, dynamic>?;
                var gastos = tarjeta?['Gastos'] as List<dynamic>? ?? [];

                return ListView.builder(
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    var gasto = gastos[index] as Map<String, dynamic>;
                    var expense = Expense(
                      id: '', // ID puede no ser necesario si no lo usas en Firestore
                      name: gasto['nombre'] ?? 'Sin nombre',
                      amount: (gasto['monto'] as num).toDouble(),
                      date: (gasto['fecha'] as Timestamp).toDate(),
                    );
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
          _deleteExpenseButton(expense),
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
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          // Obtén el documento actual de la colección
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('PerfilPrueba')
              .doc(documentId)
              .get();

          // Accede al array de gastos
          List<dynamic> gastos = doc['TarjetasCredito'][nameCard]['Gastos'];

          // Encuentra el gasto a editar
          for (var i = 0; i < gastos.length; i++) {
            if ((gastos[i]['fecha'] as Timestamp).toDate() == expense.date) {
              // Comparar por fecha, que debería ser única
              gastos[i]['nombre'] = nameController.text.isNotEmpty
                  ? nameController.text
                  : expense.name;
              gastos[i]['monto'] = amountController.text.isNotEmpty
                  ? double.parse(amountController.text)
                  : expense.amount;
              gastos[i]['fecha'] = Timestamp.fromDate(DateTime.now());
              break;
            }
          }

          // Actualiza el documento con el array de gastos modificado
          FirebaseFirestore.instance
              .collection('PerfilPrueba')
              .doc(documentId)
              .update({'TarjetasCredito.$nameCard.Gastos': gastos});

          Navigator.pop(context);
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text("Guardar"),
    );
  }

  Widget _deleteExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        // Obtén el documento actual de la colección
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('PerfilPrueba')
            .doc(documentId);

        // Obtén el documento actual
        DocumentSnapshot doc = await docRef.get();

        // Accede al array de gastos
        List<dynamic> gastos = doc['TarjetasCredito'][nameCard]['Gastos'];

        // Encuentra el índice del gasto a eliminar
        int indexToDelete = -1;
        for (var i = 0; i < gastos.length; i++) {
          if ((gastos[i]['fecha'] as Timestamp).toDate() == expense.date) {
            indexToDelete = i;
            break;
          }
        }

        if (indexToDelete != -1) {
          // Elimina el elemento del array
          gastos.removeAt(indexToDelete);

          // Actualiza el documento en Firestore con el array de gastos modificado
          await docRef.update({
            'TarjetasCredito.$nameCard.Gastos': gastos,
          });

          print('Gasto eliminado exitosamente.');
        } else {
          print('No se encontró el gasto a eliminar.');
        }

        Navigator.pop(context);
      },
      child: const Text('Borrar'),
    );
  }

  String getCardLogo(String cardNumber) {
    if (cardNumber.startsWith('34') ||
        cardNumber.startsWith('35') ||
        cardNumber.startsWith('36') ||
        cardNumber.startsWith('37')) {
      return 'assets/images/amex.png';
    } else if (cardNumber.startsWith('4')) {
      return 'assets/images/visa.png';
    } else if (cardNumber.startsWith('23') ||
        cardNumber.startsWith('24') ||
        cardNumber.startsWith('25') ||
        cardNumber.startsWith('26') ||
        cardNumber.startsWith('51') ||
        cardNumber.startsWith('52') ||
        cardNumber.startsWith('53') ||
        cardNumber.startsWith('54') ||
        cardNumber.startsWith('55')) {
      return 'assets/images/Mastercard-Logo.png';
    } else {
      return 'assets/images/Mastercard-Logo.png'; // logo por defecto
    }
  }
}
