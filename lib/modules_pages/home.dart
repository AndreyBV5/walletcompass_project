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
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationBarApp(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('TarjetaCredito').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<Widget> creditCardWidgets =
              snapshot.data!.docs.asMap().entries.map((entry) {
            int index = entry.key;
            DocumentSnapshot document = entry.value;
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            final String docId = document.id;

            return ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, _) {
                return CreditCard(
                  cardNumber: data['numeroTarjeta'],
                  cardHolderName: data['nombreTitular'],
                  expiryDate: data['fechaVencimiento'],
                  cardBackgroundImageUrl:
                      'https://cdn.mos.cms.futurecdn.net/DoZSMXF87kCuzbymsuEFHo.jpg',
                  logoAssetPath: 'assets/images/Mastercard-Logo.png',
                  onDelete: () async {
                    await FirebaseFirestore.instance
                        .collection('TarjetaCredito')
                        .doc(docId)
                        .delete();
                  },
                  isButtonVisible: currentIndex == index,
                );
              },
            );
          }).toList();

          return StackedCardCarousel(
            spaceBetweenItems: 300,
            items: creditCardWidgets,
            type: StackedCardCarouselType.cardsStack,
            onPageChanged: (index) {
              _currentIndexNotifier.value = index;
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }
}
