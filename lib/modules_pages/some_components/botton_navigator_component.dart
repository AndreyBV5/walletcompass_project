import 'package:copia_walletfirebase/modules_pages/some_components/form_creditcard_component.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarApp> {
  final int _selectedIndex = 1; // Índice seleccionado

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceEvenly, // Ajusta este valor según tus necesidades
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const FormCreditCard(),
                ),
              );
            },
            icon: Column(
              children: [
                Icon(
                  Icons.credit_card_rounded,
                  color: _selectedIndex == 0
                      ? Colors.deepPurple
                      : Colors.deepPurple,
                ),
                Text(
                  "Crear Tarjeta",
                  style: TextStyle(
                    color: _selectedIndex == 0
                        ? Colors.deepPurple
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
