import 'package:copia_walletfirebase/firebase_options.dart';
import 'package:copia_walletfirebase/login_and_register/login.dart';
import 'package:copia_walletfirebase/login_and_register/register.dart';
import 'package:copia_walletfirebase/modules_pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: const Locale('es',''),
      debugShowCheckedModeBanner: false,
      title: 'Wallet Compass',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home()
      },
    );
  }
}
