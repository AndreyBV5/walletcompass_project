import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/drawer_component.dart';

class Identification extends StatefulWidget {
  const Identification({super.key});

  @override
  State<Identification> createState() => _IdentificationState();
}

class _IdentificationState extends State<Identification> {
  List<Widget> idCards = [];

  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar los datos de Firestore
    _loadDataFromFirestore();
  }

  // Función para cargar los datos de Firestore
  Future<void> _loadDataFromFirestore() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('TarjetaCedula').get();

      // Actualiza la lista idCards con los datos obtenidos de Firestore
      setState(() {
        idCards = querySnapshot.docs.map((doc) {
          var data = doc.data();
          return IdentificationCard(
            idNumber: data['numeroCedula'].toString(), // Convertir a String
            holderName: data['nombreCompleto'],
            firstLastname: data['primerApellido'],
            secondLastname: data['segundoApellido'],
            idBackgroundImageAssetPath: "assets/images/card_bg.png",
            logoAssetPath: "assets/images/bandera-costarica.png",
            profileImageAssetPath: "assets/images/perfilcedula.jpeg",
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar los datos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavigationDrawerComponent(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: idCards.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: idCards[index],
            );
          },
        ),
      ),
    );
  }
}
