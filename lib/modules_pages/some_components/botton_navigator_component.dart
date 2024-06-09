import 'package:copia_walletfirebase/modules_pages/create_carnet.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/modules_pages/create_identification.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/form_creditcard_component.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({Key? key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBarApp> {
  String texto = 'Crear Identificación';
  int _selectedIndex = 1; // Índice seleccionado

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _uid;

  @override
  void initState() {
    super.initState();
    _getUserUID();
  }

  void _getUserUID() async {
    final User? user = _auth.currentUser;
    setState(() {
      _uid = user?.uid;
    });
  }

  // Handler para cuando se selecciona un ítem en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        if (_uid != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('PerfilPrueba').doc(_uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final document = snapshot.data!;
                    return CreateIdentificationForm(
                      documentId: document.id,
                    );
                  } else {
                    return const Text('No se encontraron datos.');
                  }
                },
              ),
            ),
          );
        }
      }
      if (_selectedIndex == 1) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FormCreditCard(),
        ));
      }
      if (_selectedIndex == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CreateCarnetForm(),
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
                color: _selectedIndex == 0 ? Colors.deepPurple : Colors.grey),
            label: "Crear Identificación",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_rounded,
                color: _selectedIndex == 1 ? Colors.deepPurple : Colors.grey),
            label: 'Crear Tarjeta',
          ),
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
