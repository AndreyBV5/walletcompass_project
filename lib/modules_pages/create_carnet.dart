import 'package:copia_walletfirebase/model/carnet_card.dart';
import 'package:flutter/material.dart';

class CreateCarnetForm extends StatefulWidget {
  const CreateCarnetForm({super.key});

  @override
  State<CreateCarnetForm> createState() => _CreateCarnetFormState();
}

class _CreateCarnetFormState extends State<CreateCarnetForm> {
  final TextEditingController numeroTarjetaController = TextEditingController();
  final TextEditingController nombreTitularController = TextEditingController();
  final TextEditingController apellidosTitularController = TextEditingController();
  final TextEditingController numeroCarnetController = TextEditingController();
  final TextEditingController fechaVencimientoController = TextEditingController();

  @override
  void dispose() {
    numeroTarjetaController.dispose();
    nombreTitularController.dispose();
    apellidosTitularController.dispose();
    numeroCarnetController.dispose();
    fechaVencimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Carnet de Estudiante'),
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
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onChanged: (text) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fechaVencimientoController,
              decoration: const InputDecoration(
                labelText: 'Fecha de Vencimiento',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    borderRadius: BorderRadius.circular(5), // Bordes redondeados con radio de 10
                  ),
                ),
                onPressed: () {
                  // Lógica para crear el carné aquí
                },
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
    );
  }
}
