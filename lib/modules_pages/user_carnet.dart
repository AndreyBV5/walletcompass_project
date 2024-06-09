import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/botton_navigator_component_carnet.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';
import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class Carnet extends StatefulWidget {
  const Carnet({super.key});

  @override
  State<Carnet> createState() => _CarnetState();
}

class _CarnetState extends State<Carnet> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      bottomNavigationBar: const BottomNavigationCarnet(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StackedCardCarousel(
          spaceBetweenItems: 260,
          items: const [
            CarnetEstudiante(
              numeroTarjeta: '12345678912',
              nombreTitular: 'Andrey David',
              apellidosTitular: 'Barrios Valverde',
              numeroCarnet: "2029",
              fechaVencimiento: '12/2026',
            ),
          ],
          type: StackedCardCarouselType.cardsStack,
          onPageChanged: (index) {
            _currentIndexNotifier.value = index;
          },
        ),
      ),
    );
  }
}
