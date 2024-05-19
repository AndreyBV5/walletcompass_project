import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:quickalert/quickalert.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/textfield_identification_widget.dart';

class CreateIdentificationForm extends StatefulWidget {
  const CreateIdentificationForm({super.key});

  @override
  State<CreateIdentificationForm> createState() =>
      _CreateIdentificationFormState();
}

class _CreateIdentificationFormState extends State<CreateIdentificationForm> {
  late final TextEditingController idNumberController;
  late final TextEditingController holderNameController;
  late final TextEditingController firstLastnameController;
  late final TextEditingController secondLastnameController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    idNumberController = TextEditingController();
    holderNameController = TextEditingController();
    firstLastnameController = TextEditingController();
    secondLastnameController = TextEditingController();
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
      await _firestore.collection('TarjetaCedula').add({
        'nombreCompleto': holderNameController.text,
        'numeroCedula': idNumberController.text,
        'primerApellido': firstLastnameController.text,
        'segundoApellido': secondLastnameController.text,
      });
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
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 60),
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
                  TextFieldIdentificationWidget(
                    label: 'Nombre completo',
                    text: holderNameController.text,
                    onChanged: (text) {
                      setState(() {
                        holderNameController.text = text;
                      });
                    },
                    prefixIcon: Icons.account_circle,
                  ),
                  const SizedBox(height: 8),
                  TextFieldIdentificationWidget(
                    label: 'Primer apellido',
                    text: firstLastnameController.text,
                    onChanged: (text) {
                      setState(() {
                        firstLastnameController.text = text;
                      });
                    },
                    prefixIcon: Icons.person,
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
    );
  }
}
