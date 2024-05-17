import 'package:flutter/material.dart';
import 'package:copia_walletfirebase/model/identification_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creando identificación'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IdentificationCard(
                    idNumber: idNumberController.text,
                    holderName: holderNameController.text,
                    firstLastname: firstLastnameController.text,
                    secondLastname: secondLastnameController.text,
                    idBackgroundImageAssetPath: "assets/images/card_bg.png",
                    logoAssetPath: "assets/images/bandera-costarica.png",
                    profileImageAssetPath: "assets/images/perfilcedula.jpeg",
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: idNumberController,
                    decoration: const InputDecoration(labelText: 'Cédula'),
                    onChanged: (_) => setState(() {}),
                  ),
                  TextFormField(
                    controller: holderNameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onChanged: (_) => setState(() {}),
                  ),
                  TextFormField(
                    controller: firstLastnameController,
                    decoration:
                        const InputDecoration(labelText: 'Primer apellido'),
                    onChanged: (_) => setState(() {}),
                  ),
                  TextFormField(
                    controller: secondLastnameController,
                    decoration:
                        const InputDecoration(labelText: 'Segundo apellido'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al presionar el botón
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Color de fondo negro
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Bordes más cuadrados
                        ),
                      ),
                      child: const Text(
                        'Crear Identificación',
                        style: TextStyle(color: Colors.white), // Letras blancas
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
