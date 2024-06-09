import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class Identification extends StatefulWidget {
  const Identification({super.key});

  @override
  State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  late PageController pageController;
  List<DocumentSnapshot> idDocuments = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _fetchDocuments();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _fetchDocuments() async {
    FirebaseFirestore.instance
        .collection('PerfilPrueba')
        .get()
        .then((snapshot) {
      setState(() {
        idDocuments = snapshot.docs;
      });
    });
  }

  void _showEditDialog(
      DocumentSnapshot doc, String cedulaKey, Map<String, dynamic> cedulaData) {
    final idNumberController =
        TextEditingController(text: cedulaData['numeroCedula'].toString());
    final holderNameController =
        TextEditingController(text: cedulaData['nombreCompleto']);
    final firstLastnameController =
        TextEditingController(text: cedulaData['primerApellido']);
    final secondLastnameController =
        TextEditingController(text: cedulaData['segundoApellido']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Identificación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idNumberController,
                  decoration: const InputDecoration(labelText: 'Cédula'),
                ),
                TextField(
                  controller: holderNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre Completo'),
                ),
                TextField(
                  controller: firstLastnameController,
                  decoration:
                      const InputDecoration(labelText: 'Primer Apellido'),
                ),
                TextField(
                  controller: secondLastnameController,
                  decoration:
                      const InputDecoration(labelText: 'Segundo Apellido'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Elimina la cédula específica en Firestore y actualiza las restantes
                try {
                  await FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    DocumentSnapshot freshSnap =
                        await transaction.get(doc.reference);
                    if (freshSnap.exists) {
                      Map<String, dynamic> data =
                          freshSnap.data() as Map<String, dynamic>;
                      Map<String, dynamic> tarjetasCedula =
                          Map<String, dynamic>.from(
                              data['TarjetasCedula'] ?? {});

                      // Elimina la cédula específica del mapa
                      tarjetasCedula.remove(cedulaKey);

                      // Actualiza los nombres de las cédulas restantes para mantenerlas en orden
                      List<String> keys = tarjetasCedula.keys.toList();
                      keys.sort((a, b) => a.compareTo(b)); // Ordena las claves
                      Map<String, dynamic> nuevasCedulas = {};
                      for (int i = 0; i < keys.length; i++) {
                        String oldKey = keys[i];
                        String newKey = 'cedula${i + 1}';
                        nuevasCedulas[newKey] = tarjetasCedula[oldKey];
                      }

                      // Actualiza el documento con el nuevo mapa de TarjetasCedula
                      transaction.update(
                          doc.reference, {'TarjetasCedula': nuevasCedulas});
                    }
                  });

                  // Actualiza los datos en la UI
                  setState(() {
                    _fetchDocuments();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al eliminar los datos: $e');
                }
              },
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                // Actualiza los datos de la cédula específica en Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('PerfilPrueba')
                      .doc(doc.id)
                      .update({
                    'TarjetasCedula.$cedulaKey': {
                      'numeroCedula': idNumberController.text,
                      'nombreCompleto': holderNameController.text,
                      'primerApellido': firstLastnameController.text,
                      'segundoApellido': secondLastnameController.text,
                    }
                  });
                  // Actualiza los datos en la UI
                  setState(() {
                    _fetchDocuments();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al actualizar los datos: $e');
                }
              },
              child:
                  const Text('Guardar', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    // Aquí puedes agregar la lógica para volver a la pantalla de inicio
    Navigator.of(context).pushReplacementNamed(
        '/home'); // Asume que '/home' es tu ruta de inicio
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(),
        drawer: const NavigationDrawerComponent(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: idDocuments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : StackedCardCarousel(
                  spaceBetweenItems: 260,
                  items: idDocuments.expand<Widget>((doc) {
                    final data = doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return []; // Maneja el caso donde data es null
                    }

                    final tarjetasCedula =
                        data['TarjetasCedula'] as Map<String, dynamic>?;
                    if (tarjetasCedula == null) {
                      return []; // Maneja el caso donde TarjetasCedula es null
                    }

                    // Extraer todas las cédulas
                    return tarjetasCedula.entries.map<Widget>((entry) {
                      final cedulaKey = entry.key;
                      final cedula = entry.value as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () => _showEditDialog(doc, cedulaKey, cedula),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: IdentificationCard(
                            idNumber: cedula['numeroCedula'].toString(),
                            holderName: cedula['nombreCompleto'],
                            firstLastname: cedula['primerApellido'],
                            secondLastname: cedula['segundoApellido'],
                            idBackgroundImageAssetPath:
                                "assets/images/card_bg.png",
                            logoAssetPath:
                                "assets/images/bandera-costarica.png",
                            profileImageAssetPath:
                                "assets/images/perfilcedula.jpeg",
                          ),
                        ),
                      );
                    }).toList();
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
