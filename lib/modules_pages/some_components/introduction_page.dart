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
          image: const Center(
              child: Icon(Icons.wallet, size: 175.0, color: Colors.deepPurple)),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 16.0),
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          title: "Administra todas tus Tarjetas",
          body:
              "Guarda y controla todos los gastos de tus tarjetas en un solo lugar.",
          image: const Center(
              child: Icon(Icons.credit_card,
                  size: 175.0, color: Colors.deepPurple)),
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
          image: const Center(
              child: Icon(Icons.badge, size: 175.0, color: Colors.deepPurple)),
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
          image: const Center(
              child: Icon(Icons.portrait_rounded,
                  size: 175.0, color: Colors.deepPurple)),
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
