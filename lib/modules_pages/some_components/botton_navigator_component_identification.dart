import 'package:copia_walletfirebase/modules_pages/create_identification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomNavigationIdentification extends StatefulWidget {
  const BottomNavigationIdentification({super.key});

  @override
  State<BottomNavigationIdentification> createState() =>
      _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationIdentification> {
  String texto = 'Crear Identificación';
  int _selectedIndex = 0; // Índice seleccionado por defecto

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

  // Handler para cuando se selecciona el ítem en el BottomNavigationBar
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
    });
  }

  @override
  Widget build(BuildContext context) => BottomAppBar(
        height: 84,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.portrait_rounded,
                    color:
                        _selectedIndex == 0 ? Colors.deepPurple : Colors.grey,
                  ),
                  Text(
                    "Crear Identificación",
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
