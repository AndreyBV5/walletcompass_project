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
      body: Stack(
        children: [
          StackedCardCarousel(
            spaceBetweenItems: 300,
            items: idCards,
            type: StackedCardCarouselType.cardsStack,
          ),
          Positioned(
            top: 55,
            right: 40,
            child: Container(
              width: 100, 
              height: 90, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/images/perfilcedula.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
