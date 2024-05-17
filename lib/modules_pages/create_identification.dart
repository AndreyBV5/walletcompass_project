import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';
import 'package:quickalert/quickalert.dart';

class CreateIdentificationForm extends StatefulWidget {
  const CreateIdentificationForm({Key? key}) : super(key: key);

  @override
  State<CreateIdentificationForm> createState() => _CreateIdentificationFormState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60), // Ajusta el margen inferior
                child: IdentificationCard(
                  idNumber: idNumberController.text,
                  holderName: holderNameController.text,
                  firstLastname: firstLastnameController.text,
                  secondLastname: secondLastnameController.text,
                  idBackgroundImageAssetPath: "assets/images/card_bg.png",
                  logoAssetPath: "assets/images/bandera-costarica.png",
                  profileImageAssetPath: "assets/images/perfilcedula.jpeg",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: idNumberController,
                decoration: const InputDecoration(labelText: 'Cédula'),
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                controller: holderNameController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                controller: firstLastnameController,
                decoration: const InputDecoration(labelText: 'Primer apellido'),
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                controller: secondLastnameController,
                decoration: const InputDecoration(labelText: 'Segundo apellido'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveDataToFirestore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Crear Identificación',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Volver',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
