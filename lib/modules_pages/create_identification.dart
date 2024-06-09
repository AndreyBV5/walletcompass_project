import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:quickalert/quickalert.dart';
import 'package:copia_walletfirebase/modules_pages/some_components/textfield_identification_widget.dart';

class CreateIdentificationForm extends StatefulWidget {
  final String documentId;

  const CreateIdentificationForm({Key? key, required this.documentId}) : super(key: key);

  @override
  State<CreateIdentificationForm> createState() => _CreateIdentificationFormState(documentId);
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
      // Verificar que los campos no estén vacíos
      if (idNumberController.text.trim().isEmpty ||
          holderNameController.text.trim().isEmpty ||
          firstLastnameController.text.trim().isEmpty ||
          secondLastnameController.text.trim().isEmpty) {
        // Mostrar un mensaje de error si algún campo está vacío
        _showErrorAlert('Por favor, complete todos los campos.');
        return;
      }

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
      _showErrorAlert('Se produjo un error al guardar los datos.');
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

  void _showErrorAlert(String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
      autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: false,
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed('/user_identification');
    return false; // Previene el comportamiento predeterminado de retroceder en la ruta
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Cédula de Estudiante'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16), // Espacio añadido para mover la tarjeta hacia arriba
                IdentificationCard(
                  idNumber: idNumberController.text,
                  holderName: holderNameController.text,
                  firstLastname: firstLastnameController.text,
                  secondLastname: secondLastnameController.text,
                  idBackgroundImageAssetPath: "assets/images/card_bg.png",
                  logoAssetPath: "assets/images/bandera-costarica.png",
                  profileImageAssetPath: "assets/images/perfilcedula.jpeg",
                ),
                const SizedBox(height: 16), // Reducido el espacio entre elementos
                Container(
                  width: double.infinity, // Ancho máximo
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldIdentificationWidget(
                        label: 'Número de identificación',
                        text: idNumberController.text,
                        onChanged: (text) {
                          setState(() {
                            idNumberController.text = text;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFieldIdentificationWidget(
                        label: 'Nombre completo',
                        text: holderNameController.text,
                        onChanged: (text) {
                          setState(() {
                            holderNameController.text = text;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldIdentificationWidget(
                        label: 'Primer apellido',
                        text: firstLastnameController.text,
                        onChanged: (text) {
                          setState(() {
                            firstLastnameController.text = text;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFieldIdentificationWidget(
                        label: 'Segundo apellido',
                        text: secondLastnameController.text,
                        onChanged: (text) {
                          setState(() {
                            secondLastnameController.text = text;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveDataToFirestore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Crear Identificación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
