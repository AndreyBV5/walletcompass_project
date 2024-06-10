import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CreateCarnetForm extends StatefulWidget {
  const CreateCarnetForm({super.key});

  @override
  State<CreateCarnetForm> createState() => _CreateCarnetFormState();
}

class _CreateCarnetFormState extends State<CreateCarnetForm> {
  final TextEditingController numeroTarjetaController = TextEditingController();
  final TextEditingController nombreTitularController = TextEditingController();
  final TextEditingController apellidosTitularController =
      TextEditingController();
  final TextEditingController numeroCarnetController = TextEditingController();
  final TextEditingController fechaVencimientoController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    numeroTarjetaController.dispose();
    nombreTitularController.dispose();
    apellidosTitularController.dispose();
    numeroCarnetController.dispose();
    fechaVencimientoController.dispose();
    super.dispose();
  }

  Future<void> _saveDataToFirestore() async {
    if (numeroTarjetaController.text.isEmpty ||
        nombreTitularController.text.isEmpty ||
        apellidosTitularController.text.isEmpty ||
        numeroCarnetController.text.isEmpty ||
        fechaVencimientoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo obtener el usuario actual.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final tarjetasCarnetRef =
          _firestore.collection('PerfilPrueba').doc(user.uid);

      final DocumentSnapshot documentSnapshot = await tarjetasCarnetRef.get();
      final Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>? ?? {};
      final Map<String, dynamic> tarjetasCarnetData =
          userData['TarjetaCarnet'] as Map<String, dynamic>? ?? {};

      final int existingCount = tarjetasCarnetData.length;
      final String newCarnetName = 'carnet${existingCount + 1}';

      final Map<String, dynamic> nuevaTarjetaCarnet = {
        'numeroTarjeta': numeroTarjetaController.text,
        'nombreTitular': nombreTitularController.text,
        'apellidosTitular': apellidosTitularController.text,
        'numeroCarnet': numeroCarnetController.text,
        'fechaVencimiento': fechaVencimientoController.text,
      };

      tarjetasCarnetData[newCarnetName] = nuevaTarjetaCarnet;

      await tarjetasCarnetRef.update({
        'TarjetaCarnet': tarjetasCarnetData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Carné creado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacementNamed('/view_carnet');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al insertar datos de carné: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushReplacementNamed('/view_carnet');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Crear Carné de Estudiante'),
          backgroundColor: const Color.fromARGB(255, 255, 251, 251),
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/view_carnet');
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CarnetEstudiante(
                numeroTarjeta: numeroTarjetaController.text,
                nombreTitular: nombreTitularController.text,
                apellidosTitular: apellidosTitularController.text,
                numeroCarnet: numeroCarnetController.text,
                fechaVencimiento: fechaVencimientoController.text,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numeroTarjetaController,
                decoration: const InputDecoration(
                  labelText: 'Número de Cédula',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nombreTitularController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Titular',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      onChanged: (text) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: apellidosTitularController,
                      decoration: const InputDecoration(
                        labelText: 'Apellidos del Titular',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      ),
                      onChanged: (text) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numeroCarnetController,
                decoration: const InputDecoration(
                  labelText: 'Número de Carné',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: fechaVencimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Vencimiento (MM/AA)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,2}/?\d{0,2}$')),
                  LengthLimitingTextInputFormatter(5),
                  _MMYYFormatter(),
                ],
                keyboardType: TextInputType.number,
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _saveDataToFirestore,
                  child: const Text(
                    'Crear Carné',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MMYYFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 2 && !newValue.text.contains('/')) {
      return TextEditingValue(
        text: '${newValue.text}/',
        selection: TextSelection.fromPosition(
          TextPosition(offset: newValue.text.length + 1),
        ),
      );
    }
    return newValue;
  }
}
