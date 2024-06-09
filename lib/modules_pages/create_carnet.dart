import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  try {
    final User? user = _auth.currentUser;
    if (user == null) {
      // Si no hay usuario autenticado, mostrar una alerta de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se pudo obtener el usuario actual.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final tarjetasCarnetRef = _firestore.collection('PerfilPrueba').doc(user.uid);

    // Obtener los datos actuales de TarjetaCarnet o un mapa vacío si no existe
    final DocumentSnapshot documentSnapshot = await tarjetasCarnetRef.get();
    final Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> tarjetasCarnetData = userData['TarjetaCarnet'] as Map<String, dynamic>? ?? {};

    // Determinar el nombre de la nueva tarjeta de carné
    final int existingCount = tarjetasCarnetData.length;
    final String newCarnetName = 'carnet${existingCount + 1}';

    // Crear el mapa de datos para la nueva tarjeta de carné
    final Map<String, dynamic> nuevaTarjetaCarnet = {
      'numeroTarjeta': numeroTarjetaController.text,
      'nombreTitular': nombreTitularController.text,
      'apellidosTitular': apellidosTitularController.text,
      'numeroCarnet': numeroCarnetController.text,
      'fechaVencimiento': fechaVencimientoController.text,
    };

    // Agregar los datos de la nueva tarjeta de carné al mapa existente
    tarjetasCarnetData[newCarnetName] = nuevaTarjetaCarnet;

    // Actualizar solo el campo TarjetaCarnet con el nuevo mapa de TarjetaCarnet
    await tarjetasCarnetRef.update({
      'TarjetaCarnet': tarjetasCarnetData,
    });

    // Mostrar una alerta de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Datos de carné insertados correctamente.'),
        backgroundColor: Colors.green,
      ),
    );

    // Navegar a la pantalla de identificación
    Navigator.of(context).pushReplacementNamed('/user_carnet');
  } catch (e) {
    // Mostrar una alerta de error si ocurre un error al guardar los datos
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
                  labelText: 'Número de Tarjeta',
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
                  const SizedBox(width: 16), // Espacio horizontal
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
                  labelText: 'Número de Carnet',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fechaVencimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Vencimiento',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                height: 48, // Altura del botón
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Color de fondo negro
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Bordes redondeados con radio de 10
                    ),
                  ),
                  onPressed: _saveDataToFirestore,
                  child: const Text(
                    'Crear Carné',
                    style: TextStyle(
                      color: Colors.white, // Color del texto blanco
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
