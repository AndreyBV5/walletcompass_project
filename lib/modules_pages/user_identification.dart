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

  void _showEditDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final idNumberController =
        TextEditingController(text: data['numeroCedula'].toString());
    final holderNameController =
        TextEditingController(text: data['nombreCompleto']);
    final firstLastnameController =
        TextEditingController(text: data['primerApellido']);
    final secondLastnameController =
        TextEditingController(text: data['segundoApellido']);

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
                // Elimina los datos en Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('TarjetaCedula')
                      .doc(doc.id)
                      .delete();
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
                // Actualiza los datos en Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('TarjetaCedula')
                      .doc(doc.id)
                      .update({
                    'numeroCedula': idNumberController.text,
                    'nombreCompleto': holderNameController.text,
                    'primerApellido': firstLastnameController.text,
                    'segundoApellido': secondLastnameController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    final cedula = entry.value as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () => _showEditDialog(doc),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: IdentificationCard(
                          idNumber: cedula['numeroCedula'].toString(),
                          holderName: cedula['nombreCompleto'],
                          firstLastname: cedula['primerApellido'],
                          secondLastname: cedula['segundoApellido'],
                          idBackgroundImageAssetPath:
                              "assets/images/card_bg.png",
                          logoAssetPath: "assets/images/bandera-costarica.png",
                          profileImageAssetPath:
                              "assets/images/perfilcedula.jpeg",
                        ),
                      ),
                    );
                  }).toList();
                }).toList(),
              ),
      ),
    );
  }
}
