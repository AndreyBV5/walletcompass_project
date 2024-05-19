import 'package:copia_walletfirebase/modules_pages/create_identification.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/form_creditcard_component.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarApp> {
  String texto = 'Crear Identificación';
  int _selectedIndex = 1; // Índice seleccionado

  // Handler para cuando se selecciona un ítem en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const CreateIdentificationForm(),
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
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait_rounded,
                color: _selectedIndex == 0
                    ? Colors.deepPurple
                    : Colors
                        .grey), // Cambiado para que sea morado cuando esté seleccionado
            label: "Crear Identificación",
            //tooltip: 'Cédula'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_rounded,
                color: _selectedIndex == 1
                    ? Colors.deepPurple
                    : Colors
                        .grey), // Cambiado para que sea morado cuando esté seleccionado
            label: 'Crear Tarjeta',
            //tooltip: 'Tarjeta'
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        currentIndex: _selectedIndex, // Índice seleccionado
        onTap: _onItemTapped, // Handler onTap para los ítems
      );
}
