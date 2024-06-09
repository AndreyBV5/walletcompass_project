import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component_carnet.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class Carnet extends StatefulWidget {
  const Carnet({super.key});

  @override
  State<Carnet> createState() => _CarnetState();
}

class _CarnetState extends State<Carnet> with SingleTickerProviderStateMixin {
  late PageController pageController;
  List<DocumentSnapshot> cardDocuments = [];
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
      FirebaseFirestore.instance
          .collection('PerfilPrueba')
          .doc(user.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            final data = snapshot.data() as Map<String, dynamic>?;

            if (data != null) {
              final tarjetasCarnet =
                  data['TarjetaCarnet'] as Map<String, dynamic>?;

              if (tarjetasCarnet != null) {
                cardDocuments = [snapshot];
              }
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationCarnet(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: cardDocuments.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : StackedCardCarousel(
                spaceBetweenItems: 260,
                items: cardDocuments.expand<Widget>((doc) {
                  final data = doc.data() as Map<String, dynamic>?;

                  if (data == null) {
                    return [];
                  }

                  final tarjetasCarnet =
                      data['TarjetaCarnet'] as Map<String, dynamic>?;
                  if (tarjetasCarnet == null) {
                    return [];
                  }

                  return tarjetasCarnet.entries.map<Widget>((entry) {
                    final cardKey = entry.key;
                    final cardData = entry.value as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () => _showDeleteConfirmationDialog(doc, cardKey),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CarnetEstudiante(
                          numeroTarjeta: cardData['numeroTarjeta'].toString(),
                          nombreTitular: cardData['nombreTitular'],
                          apellidosTitular: cardData['apellidosTitular'],
                          numeroCarnet: cardData['numeroCarnet'],
                          fechaVencimiento: cardData['fechaVencimiento'],
                        ),
                      ),
                    );
                  }).toList();
                }).toList(),
                type: StackedCardCarouselType.cardsStack,
                onPageChanged: (index) {
                  _currentIndexNotifier.value = index;
                },
              ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(DocumentSnapshot doc, String cardKey) {
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
                _deleteCardData(doc, cardKey);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCardData(DocumentSnapshot doc, String cardKey) async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(doc.reference);
        if (freshSnap.exists) {
          Map<String, dynamic> data = freshSnap.data() as Map<String, dynamic>;
          Map<String, dynamic> tarjetasCarnet = Map<String, dynamic>.from(data['TarjetaCarnet'] ?? {});

          tarjetasCarnet.remove(cardKey);

          transaction.update(doc.reference, {'TarjetaCarnet': tarjetasCarnet});
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