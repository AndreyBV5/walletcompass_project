import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component_identification.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = true; // Indicador de carga

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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('PerfilPrueba')
          .doc(user.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            final data = snapshot.data() as Map<String, dynamic>?;

            if (data != null) {
              final tarjetasCedula =
                  data['TarjetasCedula'] as Map<String, dynamic>?;

              if (tarjetasCedula != null) {
                idDocuments = [snapshot];
              }
            }
            isLoading = false; // Desactivar indicador de carga
          });
        } else {
          setState(() {
            isLoading = false; // Desactivar indicador de carga
          });
        }
      }).catchError((error) {
        setState(() {
          isLoading = false; // Desactivar indicador de carga en caso de error
        });
      });
    } else {
      setState(() {
        isLoading = false; // Desactivar indicador de carga si no hay usuario
      });
    }
  }

  void _showDeleteDialog(
      DocumentSnapshot doc, String cedulaKey, Map<String, dynamic> cedulaData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Identificación'),
          content: const Text(
              '¿Está seguro de que desea eliminar esta identificación?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
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

                      tarjetasCedula.remove(cedulaKey);

                      List<String> keys = tarjetasCedula.keys.toList();
                      keys.sort((a, b) => a.compareTo(b));
                      Map<String, dynamic> nuevasCedulas = {};
                      for (int i = 0; i < keys.length; i++) {
                        String oldKey = keys[i];
                        String newKey = 'cedula${i + 1}';
                        nuevasCedulas[newKey] = tarjetasCedula[oldKey];
                      }

                      transaction.update(
                          doc.reference, {'TarjetasCedula': nuevasCedulas});
                    }
                  });

                  setState(() {
                    _fetchDocuments();
                  });
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Identificación eliminada correctamente.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Error al eliminar los datos: $e');
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar la identificación: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed('/');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Identificaciones',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        drawer: const NavigationDrawerComponent(),
        bottomNavigationBar: const BottomNavigationIdentification(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : idDocuments.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay identificaciones disponibles',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final List<Widget> items =
                            idDocuments.expand<Widget>((doc) {
                          final data = doc.data() as Map<String, dynamic>?;

                          if (data == null) {
                            return [];
                          }

                          final tarjetasCedula =
                              data['TarjetasCedula'] as Map<String, dynamic>?;
                          if (tarjetasCedula == null) {
                            return [];
                          }

                          return tarjetasCedula.entries.map<Widget>((entry) {
                            final cedulaKey = entry.key;
                            final cedula = entry.value as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () =>
                                  _showDeleteDialog(doc, cedulaKey, cedula),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: IdentificationCard(
                                  idNumber: cedula['numeroCedula'].toString(),
                                  holderName: cedula['nombreCompleto'],
                                  firstLastname: cedula['primerApellido'],
                                  secondLastname: cedula['segundoApellido'],
                                  logoAssetPath:
                                      "assets/images/bandera-costarica.png",
                                  profileImageAssetPath:
                                      "assets/images/perfilcedula.jpeg",
                                ),
                              ),
                            );
                          }).toList();
                        }).toList();

                        return items.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay cédulas disponibles',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                            : StackedCardCarousel(
                                spaceBetweenItems: 260,
                                items: items,
                              );
                      },
                    ),
        ),
      ),
    );
  }
}
