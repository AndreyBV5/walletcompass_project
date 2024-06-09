import 'package:flutter/material.dart';

class CarnetEstudiante extends StatelessWidget {
  const CarnetEstudiante({
    super.key,
    required this.numeroTarjeta,
    required this.nombreTitular,
    required this.apellidosTitular,
    required this.numeroCarnet,
    required this.fechaVencimiento,
  });

  final String numeroTarjeta;
  final String nombreTitular;
  final String apellidosTitular;
  final String numeroCarnet;
  final String fechaVencimiento;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Carné N°',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left:
                                10),
                        child: Text(
                          numeroCarnet,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Adjusted space
                Padding(
                  padding: const EdgeInsets.only(left: 10), // Adjusted padding
                  child: Text(
                    nombreTitular,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10), // Adjusted padding
                  child: Text(
                    apellidosTitular,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Adjusted space
                Center(
                  child: Text(
                    numeroTarjeta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vence: $fechaVencimiento',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Image.asset(
                'assets/images/BN_logo.png',
                width: 40,
                height: 40,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/LOGO.png',
                width: 70,
                height: 70,
              ),
            ),
            Positioned(
              top: 50,
              right: 0,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/perfilcedula.jpeg'),
                    fit: BoxFit.cover,
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
