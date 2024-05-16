import 'package:flutter/material.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class Identification extends StatefulWidget {
  const Identification({super.key});

  @override
  State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  final List<Widget> idCards = <Widget>[
    const IdentificationCard(
      idNumber: "123456789",
      holderName: "Juan",
      firstLastname: "Pérez",
      secondLastname: "Gómez",
      idBackgroundImageAssetPath: "assets/images/card_bg.png",
      logoAssetPath: "assets/images/bandera-costarica.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      body: StackedCardCarousel(
        spaceBetweenItems: 300,
        items: idCards,
        type: StackedCardCarouselType.cardsStack,
      ),
    );
  }
}
