import 'package:flutter/material.dart';

class IdentificationCard extends StatelessWidget {
  const IdentificationCard({
    super.key,
    required this.idNumber,
    required this.holderName,
    required this.birthDate,
    required this.idBackgroundImageAssetPath,
    required this.logoAssetPath,
  });

  final String idNumber;
  final String holderName;
  final String birthDate;
  final String idBackgroundImageAssetPath;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(idBackgroundImageAssetPath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 20,
                  child: Image.asset(
                    logoAssetPath,
                    height: 30,
                    width: 25,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end, // Alinea el texto a la derecha
                    children: [
                      Text(
                        'REPúBLICA DE COSTA RICA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Tribunal Supremo de Elecciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        'Cédula de Identificación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                idNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
            ),
            Row( // Coloca holderName y birthDate en la misma fila
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  holderName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  birthDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
