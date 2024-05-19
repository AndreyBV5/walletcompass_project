import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({
    super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardBackgroundImageUrl,
    required this.logoAssetPath,
    this.onLongPress,
    required this.onTap,
  });

  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardBackgroundImageUrl;
  final String logoAssetPath;
  final VoidCallback? onLongPress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress != null
          ? () => _showDeleteConfirmationDialog(context)
          : null,
      child: Container(
        height: 250,
        width: 350,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(cardBackgroundImageUrl),
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
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  logoAssetPath,
                  height: 50,
                  width: 50,
                ),
              ),
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    expiryDate,
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
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar tarjeta'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta tarjeta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                onLongPress
                    ?.call(); // Ejecutar la función de eliminar si no es null
              },
            ),
          ],
        );
      },
    );
  }
}
