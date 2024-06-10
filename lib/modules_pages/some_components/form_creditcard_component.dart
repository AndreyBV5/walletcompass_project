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
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return WillPopScope(
      onWillPop: () async {
        if (!_isNavigating) {
          setState(() {
            _isNavigating = true;
          });
          await Future.delayed(Duration(milliseconds: 100));
          Navigator.of(context).pushReplacementNamed('/view_credit_card');
        }
        return false;
      },
      child: MaterialApp(
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
                if (!_isNavigating) {
                  setState(() {
                    _isNavigating = true;
                  });
                  Navigator.of(context)
                      .pushReplacementNamed('/view_credit_card');
                }
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
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;

        if (user != null) {
          int numeroTarjetas = await obtenerNumeroTarjetasCredito(user.uid);
          int siguienteNumeroTarjeta = numeroTarjetas + 1;

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

          if (!_isNavigating) {
            setState(() {
              _isNavigating = true;
            });
            Navigator.of(context).pushReplacementNamed('/view_credit_card');
          }
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
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        Map<String, dynamic> nuevaTarjeta = {
          'nombreTitular': nombreTitular,
          'numeroTarjeta': numeroTarjeta,
          'fechaExpiracion': fechaExpiracion,
          'cvv': cvv,
        };

        String nombreNuevaTarjeta = 'Tarjeta$numeroTarjetaActual';

        tarjetasCredito[nombreNuevaTarjeta] = nuevaTarjeta;

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
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('PerfilPrueba').doc(userId);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        Map<String, dynamic> data =
            userDocSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> tarjetasCredito =
            Map<String, dynamic>.from(data['TarjetasCredito'] ?? {});

        return tarjetasCredito.length;
      } else {
        return 0;
      }
    } catch (error) {
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
