import 'package:copia_walletfirebase/modules_pages/user_carnet.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarApp> {
  int _selectedIndex = 1; // Índice seleccionado

  @override
  void initState() {
    super.initState();
  }

  // Handler para cuando se selecciona un ítem en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Carnet(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_rounded,
                color: _selectedIndex == 2 ? Colors.deepPurple : Colors.grey),
            label: 'Crear Carné',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        currentIndex: _selectedIndex, // Índice seleccionado
        onTap: _onItemTapped, // Handler onTap para los ítems
      );
}
