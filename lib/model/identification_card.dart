import 'package:flutter/material.dart';

class IdentificationCard extends StatelessWidget {
  const IdentificationCard({
    super.key,
    required this.idNumber,
    required this.holderName,
    required this.firstLastname,
    required this.secondLastname,
    required this.logoAssetPath,
    this.profileImageAssetPath,
  });

  final String idNumber;
  final String holderName;
  final String firstLastname;
  final String secondLastname;
  final String logoAssetPath;
  final String? profileImageAssetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 196, 218, 229), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
              bottom: 110,
              right: 5,
              child: Container(
                width: 90, 
                height: 100, 
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: profileImageAssetPath == null
                    ? const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 40,
                        ),
                      )
                    : null,
              ),
            ),
            Column(
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'REPÚBLICA DE COSTA RICA',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Tribunal Supremo de Elecciones',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Cédula de Identificación',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0, right: 35.0),
                  child: Center(
                    child: Text(
                      idNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Nombre: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                              ),
                            ),
                            TextSpan(
                              text: holderName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '1° Apellido: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                            ),
                          ),
                          TextSpan(
                            text: firstLastname,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '2° Apellido: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                            ),
                          ),
                          TextSpan(
                            text: secondLastname,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
