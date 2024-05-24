import 'package:flutter/material.dart';

class CarnetEstudiante extends StatelessWidget {
  const CarnetEstudiante({
    Key? key,
    required this.numeroTarjeta,
    required this.fechaVencimiento,
    required this.nombreTitular,
    required this.numeroCuenta,
  }) : super(key: key);

  final String numeroTarjeta;
  final String fechaVencimiento;
  final String nombreTitular;
  final String numeroCuenta;

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
              'VALID THRU: $fechaVencimiento',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
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
              numeroCuenta,
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
