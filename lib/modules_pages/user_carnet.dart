import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component_carnet.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';

class Carnet extends StatefulWidget {
  const Carnet({Key? key});

  @override
  State<Carnet> createState() => _CarnetState();
}

class _CarnetState extends State<Carnet> with SingleTickerProviderStateMixin {
  late PageController pageController;
  List<Map<String, dynamic>> cardDocuments = [];
  bool isLoading = true;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

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
      final snapshot = await FirebaseFirestore.instance
          .collection('PerfilPrueba')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          final tarjetasCarnet = data['TarjetaCarnet'] as Map<String, dynamic>?;

          if (tarjetasCarnet != null) {
            setState(() {
              cardDocuments = tarjetasCarnet.entries
                  .map((entry) => {'key': entry.key, 'data': entry.value})
                  .toList();
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationCarnet(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : cardDocuments.isEmpty
                ? SingleChildScrollView(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 300),
                        child: const Text(
                          'No hay carnés disponibles',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : Builder(
                    builder: (context) {
                      final List<Widget> items = cardDocuments
                          .map((card) => GestureDetector(
                                onTap: () => _showDeleteConfirmationDialog(
                                    card['key'], card['data']),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CarnetEstudiante(
                                    numeroTarjeta: card['data']['numeroTarjeta']
                                        .toString(),
                                    nombreTitular: card['data']
                                        ['nombreTitular'],
                                    apellidosTitular: card['data']
                                        ['apellidosTitular'],
                                    numeroCarnet: card['data']['numeroCarnet'],
                                    fechaVencimiento: card['data']
                                        ['fechaVencimiento'],
                                  ),
                                ),
                              ))
                          .toList();

                      return items.isEmpty
                          ? SingleChildScrollView(
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 300),
                                  child: const Text(
                                    'No hay carnés disponibles',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : StackedCardCarousel(
                              spaceBetweenItems: 260,
                              items: items,
                              type: StackedCardCarouselType.cardsStack,
                              onPageChanged: (index) {
                                _currentIndexNotifier.value = index;
                              },
                            );
                    },
                  ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      String cardKey, Map<String, dynamic> cardData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Carné'),
          content: const Text('¿Está seguro de que desea eliminar este carné?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteCardData(cardKey);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCardData(String cardKey) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(FirebaseFirestore.instance
              .collection('PerfilPrueba')
              .doc(user.uid));

          if (snapshot.exists) {
            final Map<String, dynamic> data =
                snapshot.data() as Map<String, dynamic>;
            final Map<String, dynamic> tarjetasCarnet =
                Map<String, dynamic>.from(data['TarjetaCarnet'] ?? {});

            tarjetasCarnet.remove(cardKey);

            transaction
                .update(snapshot.reference, {'TarjetaCarnet': tarjetasCarnet});
          }
        });

        setState(() {
          _fetchDocuments();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carné eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error al eliminar el carné: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el carné: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
