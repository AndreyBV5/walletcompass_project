import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ButtonState stateTextWithIcon = ButtonState.idle;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showClearUsername = false;
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
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Text(
                    "Registrarse",
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
                    controller: usernameController,
                    onChanged: (value) {
                      setState(() {
                        showClearUsername = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: showClearUsername
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  usernameController.clear();
                                  showClearUsername = false;
                                });
                              },
                            )
                          : null,
                      labelText: "Nombre de usuario",
                      helperText: "Ingresa tu nombre de usuario",
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
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
                      labelText: "Correo electrónico",
                      helperText: "Ingresa tu correo electrónico",
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    textAlign: TextAlign.start,
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
                    obscureText: true,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: buildTextWithIcon(),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("¿Ya estás registrado?"),
                      InkWell(
                        child: const Text(
                          " Inicia Sesión",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
          text: "Crear cuenta",
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

  void agregarDatosEnPerfil(
      String username, String email, String password) async {
    try {
      // Obtener una referencia a la colección "PerfilPrueba"
      CollectionReference perfilCollection =
          FirebaseFirestore.instance.collection('PerfilPrueba');

      // Obtener el ID del usuario actual
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Crear un documento con el ID del usuario
      await perfilCollection.doc(userId).set({
        'nombreUsuario': username,
        'correo': email,
        'contraseña': password,
      });

      print(
          'Datos agregados exitosamente en PerfilPrueba con el ID del usuario: $userId');
    } catch (error) {
      print('Error al agregar datos en PerfilPrueba: $error');
    }
  }

  void onPressedIconWithText() async {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        setState(() {
          stateTextWithIcon = ButtonState.loading;
        });
        try {
          final UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          if (userCredential.user != null) {
            setState(() {
              stateTextWithIcon = ButtonState.success;
            });

            // Insertar los datos en la colección Perfil
            agregarDatosEnPerfil(
              usernameController.text,
              emailController.text,
              passwordController.text,
            );

            // Realizar la navegación después de registrar al usuario con éxito
            Timer(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              }
            });
          }
        } catch (e) {
          print("Error al registrar usuario: $e");
          setState(() {
            stateTextWithIcon = ButtonState.fail;
          });
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
    paint.color = const Color.fromARGB(255, 57, 55, 133);
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
