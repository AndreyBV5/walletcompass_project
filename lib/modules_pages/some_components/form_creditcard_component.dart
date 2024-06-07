import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormCreditCard extends StatefulWidget {
  const FormCreditCard({super.key});

  @override
  State<FormCreditCard> createState() => _FormCreditCardState();
}

class _FormCreditCardState extends State<FormCreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      // locale: const Locale('es', ''),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.7),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.7),
              width: 2.0,
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.black),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Crear Tarjeta",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CreditCardWidget(
                  enableFloatingCard: true,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'CR',
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.black,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _onValidate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: const Text(
                              'Crear',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;

        if (user != null) {
          // Obtener el número actual de tarjetas de crédito del usuario
          int numeroTarjetas = await obtenerNumeroTarjetasCredito(user.uid);

          // Obtener el siguiente número de tarjeta disponible
          int siguienteNumeroTarjeta = numeroTarjetas + 1;

          // Llamar a guardarDatosTarjetaCredito con el siguiente número de tarjeta disponible
          guardarDatosTarjetaCredito(
            user.uid,
            cardHolderName,
            cardNumber,
            expiryDate,
            cvvCode,
            siguienteNumeroTarjeta,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Datos de tarjeta de crédito insertados correctamente.'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No se pudo obtener el usuario actual.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al insertar datos de tarjeta de crédito: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void guardarDatosTarjetaCredito(
      String userId,
      String nombreTitular,
      String numeroTarjeta,
      String fechaExpiracion,
      String cvv,
      int numeroTarjetaActual) async {
    try {
      // Obtener una referencia al documento del usuario en la colección "PerfilPrueba"
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      // Verificar si el documento del usuario existe
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Obtener el mapa actual de TarjetasCredito
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        // Crear un nuevo mapa para los datos de la nueva tarjeta
        Map<String, dynamic> nuevaTarjeta = {
          'nombreTitular': nombreTitular,
          'numeroTarjeta': numeroTarjeta,
          'fechaExpiracion': fechaExpiracion,
          'cvv': cvv,
        };

        // Nombre de la nueva tarjeta (por ejemplo, "Tarjeta1", "Tarjeta2", etc.)
        String nombreNuevaTarjeta = 'Tarjeta$numeroTarjetaActual';

        // Agregar la nueva tarjeta al mapa de TarjetasCredito
        tarjetasCredito[nombreNuevaTarjeta] = nuevaTarjeta;

        // Actualizar el documento con el nuevo mapa de TarjetasCredito
        await userDocRef.update({'TarjetasCredito': tarjetasCredito});

        print('Datos de la tarjeta de crédito insertados correctamente');
      } else {
        print('Error: El documento del usuario no existe');
      }
    } catch (error) {
      print('Error al insertar datos de tarjeta de crédito: $error');
    }
  }

  Future<int> obtenerNumeroTarjetasCredito(String userId) async {
    try {
      // Obtener una referencia al documento del usuario en la colección "PerfilPrueba"
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      // Obtener el documento del usuario
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Verificar si el documento del usuario existe
      if (userDocSnapshot.exists) {
        // Obtener el mapa actual de TarjetasCredito
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        // Devolver el número de tarjetas de crédito actuales
        return tarjetasCredito.length;
      } else {
        // Si el documento no existe, retornar 0
        return 0;
      }
    } catch (error) {
      // Manejar errores y retornar 0 en caso de error
      print('Error al obtener el número de tarjetas de crédito: $error');
      return 0;
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
