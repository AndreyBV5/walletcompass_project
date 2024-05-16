import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({
    super.key,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardBackgroundImageUrl,
    required this.logoAssetPath,
    required this.onDelete,
    required this.isButtonVisible,
  });

  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardBackgroundImageUrl;
  final String logoAssetPath;
  final VoidCallback onDelete;
  final bool isButtonVisible;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
        const SizedBox(height: 10),
        Visibility(
          visible: isButtonVisible,
          child: ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
