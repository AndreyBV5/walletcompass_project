
import 'package:copia_walletfirebase/login_and_register/login.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/form_creditcard_component.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarApp> {
  int _selectedIndex = 1; // Índice seleccionado

  // Handler para cuando se selecciona un ítem en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Login(),
        ));
      }
      if (_selectedIndex == 1) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FormCreditCard(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_sharp),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Crear Tarjeta',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        currentIndex: _selectedIndex, // Índice seleccionado
        onTap: _onItemTapped, // Handler onTap para los ítems
      );
}
