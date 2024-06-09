import 'dart:async';
import 'package:copia_walletfirebase/modules_pages/some_components/introduction_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'forgot_password.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ButtonState stateTextWithIcon = ButtonState.idle;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showClearEmail = false;
  bool showClearPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 57, 55, 133),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: TextField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          showClearEmail = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: showClearEmail
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    emailController.clear();
                                    showClearEmail = false;
                                  });
                                },
                              )
                            : null,
                        labelText: "Correo",
                        helperText: "Ingresa tu correo electrónico",
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 80,
                    child: TextField(
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          showClearPassword = value.isNotEmpty;
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: showClearPassword
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    passwordController.clear();
                                    showClearPassword = false;
                                  });
                                },
                              )
                            : null,
                        labelText: "Contraseña",
                        helperText: "Ingresa tu contraseña",
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
                  const SizedBox(height: 90),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("¿No estás registrado?"),
                        InkWell(
                          child: const Text(
                            " Registrarse",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: const Text(
                            "Recordar contraseña",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          text: "Iniciar Sesión",
          icon: Icon(Icons.person, color: Colors.white),
          color: Color.fromARGB(255, 57, 55, 133),
        ),
        ButtonState.loading: IconedButton(
          text: "Cargando",
          color: Colors.deepPurple.shade700,
        ),
        ButtonState.fail: IconedButton(
          text: "Error",
          icon: const Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade300,
        ),
        ButtonState.success: IconedButton(
          text: "",
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400,
        )
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
        try {
          final UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          // Si el inicio de sesión es exitoso, establece el estado a éxito
          if (userCredential.user != null) {
            setState(() {
              stateTextWithIcon = ButtonState.success;
            });
            // Realizar la navegación solo después de que la animación haya terminado
            Timer(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const IntroductionPage(),
                  ),
                );
                // Establecer el estado del botón a 'idle' después de navegar a la pantalla de inicio
                setState(() {
                  stateTextWithIcon = ButtonState.idle;
                });
              }
            });
          } else {
            // Si no se encuentra un usuario, establece el estado a fallar
            setState(() {
              stateTextWithIcon = ButtonState.fail;
            });
            // Establecer el estado del botón a 'idle' después de 2 segundos
            Timer(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  stateTextWithIcon = ButtonState.idle;
                });
              }
            });
          }
        } catch (e) {
          // Si ocurre algún error durante el inicio de sesión, establece el estado a fallar
          setState(() {
            stateTextWithIcon = ButtonState.fail;
          });
          // Establecer el estado del botón a 'idle' después de 2 segundos
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            }
          });
          print("Error al iniciar sesión: $e");
        }
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        // Establecer el estado del botón a 'idle' después de 2 segundos
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          }
        });
        break;
      case ButtonState.fail:
        // Establecer el estado del botón a 'idle' después de 2 segundos
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
    paint.color = const Color.fromARGB(255, 57, 55, 133);
    paint.style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height * 1.0);
    path.lineTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width, size.height * 1.0);
    path.lineTo(size.width, size.height * 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
