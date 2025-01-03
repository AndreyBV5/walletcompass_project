import 'package:flutter/material.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({
    super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.logoAssetPath,
    this.onLongPress,
    required this.onTap,
  });

  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String logoAssetPath;
  final VoidCallback? onLongPress;
  final VoidCallback onTap;

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () => _showDeleteConfirmationDialog(context)
          : null,
      child: Container(
        height: 250,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.black,
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
                  widget.logoAssetPath,
                  height: 50,
                  width: 50,
                ),
              ),
              Text(
                _formatCardNumber(widget.cardNumber),
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
                    widget.cardHolderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.expiryDate,
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

  String _formatCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) {
      return cardNumber; // Si el número de tarjeta tiene 4 dígitos o menos, no censurar ni formatear
    }
    String censored = cardNumber.replaceRange(
        0, cardNumber.length - 4, 'X' * (cardNumber.length - 4));
    return _addSpaces(censored);
  }

  String _addSpaces(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i % 4 == 0 && i != 0) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
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
                widget.onLongPress
                    ?.call(); // Ejecutar la función de eliminar si no es null
              },
            ),
          ],
        );
      },
    );
  }
}
