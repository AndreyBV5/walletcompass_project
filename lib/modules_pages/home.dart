
import 'package:copia_walletfirebase/model/credit_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationBarApp(),
      body: StreamBuilder<QuerySnapshot>(
        // Utiliza un StreamBuilder para obtener los datos de Firestore
        stream:
            FirebaseFirestore.instance.collection('TarjetaCredito').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se cargan los datos
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Muestra un mensaje de error si hay un error al obtener los datos
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Mapea los documentos de la colección a objetos CreditCard
          final List<CreditCard> creditCards =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return CreditCard(
              cardNumber: data['numeroTarjeta'],
              cardHolderName: data['nombreTitular'],
              expiryDate: data['fechaVencimiento'],
              cardBackgroundImageUrl:
                  'https://cdn.mos.cms.futurecdn.net/DoZSMXF87kCuzbymsuEFHo.jpg',
              logoAssetPath: 'assets/images/Mastercard-Logo.png',
            );
          }).toList();

          return StackedCardCarousel(
            spaceBetweenItems: 300,
            items: creditCards,
            type: StackedCardCarouselType.cardsStack,
          );
        },
      ),
    );
  }
}
