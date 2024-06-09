import 'package:copia_walletfirebase/modules_pages/user_tarjet_credit.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Bienvenido a WalletCompass",
          body: "Tu billetera virtual segura y confiable.",
          image: const Padding(
            padding: EdgeInsets.only(
                top: 60), // Ajusta este valor según sea necesario
            child: CircleAvatar(
              radius: 140,
              backgroundImage: AssetImage('assets/images/Logo.jpeg'),
            ),
          ),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(
              fontSize: 19.0,
            ),
            pageColor: Color.fromARGB(255, 233, 247, 236),
          ),
        ),
        PageViewModel(
          title: "Administra todas tus Tarjetas",
          body:
              "Guarda y controla todos los gastos de tus tarjetas en un solo lugar.",
          image: const Image(
            image: AssetImage('assets/images/tarjetas.png'),
            height: 250,
          ),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16.0),
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "Crea tus Identificaciones",
          body: "Mantén todas tus identificaciones y de familiares a la mano.",
          image: const Image(
            image: AssetImage('assets/images/cedula.png'),
            height: 250,
          ),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16.0),
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "Guarda tus Carnets",
          body: "Mantén todos tus carnets organizados y a la mano.",
          image: const Image(
            image: AssetImage('assets/images/carnet.png'),
            height: 250,
          ),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16.0),
            pageColor: Colors.white,
          ),
        ),
      ],
      onDone: () {
        // Cuando el usuario completa la introducción
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Home()),
        );
      },
      globalBackgroundColor: Colors.white,
      showSkipButton: true,
      skip: const Text("Saltar"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Hecho", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
