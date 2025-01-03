
import 'package:copia_walletfirebase/login_and_register/login.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'dart:async';
import 'dart:math';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});


  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: BackgroundPainter(),
              size: Size(MediaQuery.of(context).size.width, 250),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Text("Recordar contraseña",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 124, 85, 173))),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: const Icon(Icons.clear),
                        labelText: "Correo electronico",
                        hintText: "Andrey@gmail.com",
                        helperText: "Ingresa tu correo electronico",
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: buildTextWithIcon(),
                ),
                const SizedBox(height: 180),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("¿Ya estás registrado?"),
                      InkWell(
                        child: const Text(" Inicia Sesion",
                            style: TextStyle(
                                decoration: TextDecoration.underline)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      radius: 10.0,
      iconedButtons: {
        ButtonState.idle: const IconedButton(
            text: "Recuperar contraseña",
            icon: Icon(Icons.lock_open, color: Colors.white),
            color: Color.fromARGB(255, 180, 148, 221)),
        ButtonState.loading:
            IconedButton(text: "Cargando", color: Colors.deepPurple.shade700),
        ButtonState.fail: IconedButton(
            text: "Error",
            icon: const Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: "",
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: onPressedIconWithText,
      state: stateTextWithIcon,
    );
  }
  
  
  void onPressedIconWithText() async {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        setState(() {
          stateTextWithIcon = ButtonState.loading;
        });
        await Future.delayed(const Duration(
            seconds: 2)); // Simular operación de inicio de sesión
        setState(() {
          stateTextWithIcon = Random.secure().nextBool()
              ? ButtonState.success
              : ButtonState.fail;
        });

        if (stateTextWithIcon == ButtonState.success) {
          // Mostrar la animación de éxito durante un breve período de tiempo
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            }
          });

          // Realizar la navegación solo después de que la animación haya terminado
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            }
          });
        } else {
          // Mostrar el estado de falla durante un breve período de tiempo
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            }
          });
        }
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        break;
      case ButtonState.fail:
        // Mostrar el estado de falla durante un breve período de tiempo
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          }
        });
        break;
    }
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = const Color.fromARGB(255, 180, 148, 221);
    paint.style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height * 1.0);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    path.lineTo(size.width, size.height * 1.0);
    path.lineTo(size.width, size.height * 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
