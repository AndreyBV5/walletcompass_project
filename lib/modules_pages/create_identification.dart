import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:quickalert/quickalert.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/textfield_identification_widget.dart';

class CreateIdentificationForm extends StatefulWidget {
  final String documentId;

  const CreateIdentificationForm({super.key, required this.documentId});

  @override
  State<CreateIdentificationForm> createState() =>
      _CreateIdentificationFormState(documentId);
}

class _CreateIdentificationFormState extends State<CreateIdentificationForm> {
  late final TextEditingController idNumberController;
  late final TextEditingController holderNameController;
  late final TextEditingController firstLastnameController;
  late final TextEditingController secondLastnameController;
  final String documentId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _uid;

  _CreateIdentificationFormState(this.documentId);

  @override
  void initState() {
    super.initState();
    _getUserUID();
    idNumberController = TextEditingController();
    holderNameController = TextEditingController();
    firstLastnameController = TextEditingController();
    secondLastnameController = TextEditingController();
  }

  void _getUserUID() async {
    final User? user = _auth.currentUser;
    setState(() {
      _uid = user?.uid;
    });
  }

  @override
  void dispose() {
    idNumberController.dispose();
    holderNameController.dispose();
    firstLastnameController.dispose();
    secondLastnameController.dispose();
    super.dispose();
  }

  Future<void> _saveDataToFirestore() async {
    try {
      final tarjetasCedulaRef = _firestore.collection('PerfilPrueba').doc(_uid);

      final DocumentSnapshot documentSnapshot = await tarjetasCedulaRef.get();
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>? ?? {};
      final Map<String, dynamic> tarjetasCedula =
          data['TarjetasCedula'] as Map<String, dynamic>? ?? {};

      final int existingCount = tarjetasCedula.length;
      final String newCedulaName = 'cedula${existingCount + 1}';

      tarjetasCedula[newCedulaName] = {
        'nombreCompleto': holderNameController.text,
        'numeroCedula': idNumberController.text,
        'primerApellido': firstLastnameController.text,
        'segundoApellido': secondLastnameController.text,
      };

      await tarjetasCedulaRef.set({
        'TarjetasCedula': tarjetasCedula,
      }, SetOptions(merge: true));

      _showSuccessAlert();
    } catch (e) {
      print('Error al guardar los datos: $e');
    }
  }

  void _showSuccessAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Éxito',
      text: 'Identificación creada correctamente',
      autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed('/home');
    return false; // Prevents the default behavior of popping the route
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 251, 251),
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 255, 251, 251),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Crear Cédula",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    IdentificationCard(
                      idNumber: idNumberController.text,
                      holderName: holderNameController.text,
                      firstLastname: firstLastnameController.text,
                      secondLastname: secondLastnameController.text,
                      idBackgroundImageAssetPath: "assets/images/card_bg.png",
                      logoAssetPath: "assets/images/bandera-costarica.png",
                      profileImageAssetPath: "assets/images/perfilcedula.jpeg",
                    ),
                    const SizedBox(height: 30),
                    TextFieldIdentificationWidget(
                      label: 'Número de identificación',
                      text: idNumberController.text,
                      onChanged: (text) {
                        setState(() {
                          idNumberController.text = text;
                        });
                      },
                      prefixIcon: Icons.credit_card,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldIdentificationWidget(
                            label: 'Nombre completo',
                            text: holderNameController.text,
                            onChanged: (text) {
                              setState(() {
                                holderNameController.text = text;
                              });
                            },
                            prefixIcon: Icons.account_circle,
                          ),
                        ),
                        const SizedBox(width: 16), // Espacio entre los campos
                        Expanded(
                          child: TextFieldIdentificationWidget(
                            label: 'Primer apellido',
                            text: firstLastnameController.text,
                            onChanged: (text) {
                              setState(() {
                                firstLastnameController.text = text;
                              });
                            },
                            prefixIcon: Icons.person,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFieldIdentificationWidget(
                      label: 'Segundo apellido',
                      text: secondLastnameController.text,
                      onChanged: (text) {
                        setState(() {
                          secondLastnameController.text = text;
                        });
                      },
                      prefixIcon: Icons.person_2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _saveDataToFirestore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 80),
                            child: Text(
                              'Crear Identificación',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
