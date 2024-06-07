import 'package:copia_walletfirebase/model/credit_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'expense_control.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Billetera",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationBarApp(),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError || userSnapshot.data == null) {
            return Center(
                child: Text('Error: No se pudo obtener el usuario actual.'));
          }

          final String userId = userSnapshot.data!.uid;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('PerfilPrueba')
                .doc(
                    userId) // Usar el UID del usuario actual como ID del documento
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final Map<String, dynamic>? userData =
                  snapshot.data?.data() as Map<String, dynamic>?;
              if (userData == null) {
                // Si el documento del usuario no existe, muestra un mensaje de error
                return Center(
                    child: Text('Error: El documento del usuario no existe.'));
              }

              final Map<String, dynamic>? tarjetasCreditoData =
                  userData['TarjetasCredito'];
              if (tarjetasCreditoData == null || tarjetasCreditoData.isEmpty) {
                return const Center(
                    child: Text('No hay tarjetas de crédito disponibles.'));
              }

              final List<Widget> creditCardWidgets =
                  tarjetasCreditoData.entries.map((entry) {
                final String cardId = entry.key;
                final Map<String, dynamic> cardData = entry.value;

                return ValueListenableBuilder<int>(
                  valueListenable: _currentIndexNotifier,
                  builder: (context, currentIndex, _) {
                    return CreditCard(
                      cardNumber: cardData['numeroTarjeta'],
                      cardHolderName: cardData['nombreTitular'],
                      expiryDate: cardData['fechaExpiracion'],
                      cardBackgroundImageUrl:
                          'https://cdn.mos.cms.futurecdn.net/DoZSMXF87kCuzbymsuEFHo.jpg',
                      logoAssetPath: 'assets/images/Mastercard-Logo.png',
                      onLongPress: () async {
                        await FirebaseFirestore.instance
                            .collection('PerfilPrueba')
                            .doc(userId)
                            .update({
                          'TarjetasCredito.$cardId': FieldValue.delete(),
                        });

                        // Obtener el número actual de tarjetas de crédito del usuario
                        int numeroTarjetas =
                            await obtenerNumeroTarjetasCredito(userId);

                        // Actualizar los nombres de las tarjetas restantes para mantenerlas en orden
                        await actualizarNombresTarjetas(
                            userId, numeroTarjetas, cardId);

                        // Actualizar el índice seleccionado si es necesario
                        _currentIndexNotifier.value = 0;
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpenseControl(cardId:userData['TarjetasCredito']),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList();

              return StackedCardCarousel(
                spaceBetweenItems: 260,
                items: creditCardWidgets,
                type: StackedCardCarouselType.cardsStack,
                onPageChanged: (index) {
                  _currentIndexNotifier.value = index;
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<int> obtenerNumeroTarjetasCredito(String userId) async {
    try {
      // Obtener una referencia al documento del usuario en la colección "PerfilPrueba"
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      // Obtener el documento del usuario
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Verificar si el documento del usuario existe
      if (userDocSnapshot.exists) {
        // Obtener el mapa actual de TarjetasCredito
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        // Devolver el número de tarjetas de crédito actuales
        return tarjetasCredito.length;
      } else {
        // Si el documento no existe, retornar 0
        return 0;
      }
    } catch (error) {
      // Manejar errores y retornar 0 en caso de error
      print('Error al obtener el número de tarjetas de crédito: $error');
      return 0;
    }
  }

  Future<void> actualizarNombresTarjetas(
      String userId, int numeroTarjetas, String tarjetaEliminada) async {
    try {
      print('Actualizando nombres de tarjetas...');
      // Obtener una referencia al documento del usuario en la colección "PerfilPrueba"
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      // Obtener el documento del usuario
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Verificar si el documento del usuario existe
      if (userDocSnapshot.exists) {
        // Obtener el mapa actual de TarjetasCredito
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        // Eliminar la tarjeta eliminada del mapa de tarjetas
        tarjetasCredito.remove(tarjetaEliminada);

        // Actualizar los nombres de las tarjetas restantes para mantenerlas en orden
        List<String> keys = tarjetasCredito.keys.toList();
        keys.sort();
        Map<String, dynamic> nuevasTarjetasCredito = {};
        for (int i = 0; i < keys.length; i++) {
          String oldKey = keys[i];
          String newKey = 'Tarjeta${i + 1}';
          nuevasTarjetasCredito[newKey] = tarjetasCredito[oldKey];
        }

        // Actualizar el documento con el nuevo mapa de TarjetasCredito
        await userDocRef.update({'TarjetasCredito': nuevasTarjetasCredito});

        print('Nombres de las tarjetas actualizados correctamente');
      } else {
        print('Error: El documento del usuario no existe');
      }
    } catch (error) {
      print('Error al actualizar nombres de tarjetas: $error');
    }
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
