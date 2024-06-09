import 'package:copia_walletfirebase/modules_pages/create_carnet.dart';
import 'package:flutter/material.dart';

class BottomNavigationCarnet extends StatefulWidget {
  const BottomNavigationCarnet({super.key});

  @override
  State<BottomNavigationCarnet> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationCarnet> {
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
                  builder: (context) => const CreateCarnetForm(),
                ),
              );
            },
            icon: Column(
              children: [
                Icon(
                  Icons.portrait_rounded,
                  color: _selectedIndex == 0
                      ? Colors.deepPurple
                      : Colors.deepPurple,
                ),
                Text(
                  "Crear Carné",
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
