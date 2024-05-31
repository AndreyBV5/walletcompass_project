import 'package:flutter/material.dart';

class CarnetEstudiante extends StatelessWidget {
  const CarnetEstudiante({
    super.key,
    required this.numeroTarjeta,
    required this.nombreTitular,
    required this.apellidosTitular,
    required this.numeroCarnet,
  });

  final String numeroTarjeta;
  final String nombreTitular;
  final String apellidosTitular;
  final String numeroCarnet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              numeroTarjeta,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
            Text(
              nombreTitular,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              apellidosTitular,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              numeroCarnet,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
