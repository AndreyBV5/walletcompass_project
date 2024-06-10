import 'package:copia_walletfirebase/modules_pages/user_tarjet_credit.dart';
import 'package:copia_walletfirebase/modules_pages/user_carnet.dart';
import 'package:copia_walletfirebase/modules_pages/user_identification.dart';
import 'package:flutter/material.dart';

class NavigationDrawerComponent extends StatefulWidget {
  const NavigationDrawerComponent({super.key});

  @override
  State<NavigationDrawerComponent> createState() =>
      _NavigationDrawerComponentState();
}

class _NavigationDrawerComponentState extends State<NavigationDrawerComponent> {
  bool isImageExpanded = false; // Estado para controlar el tamaño de la imagen

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: const Color.fromARGB(255, 57, 55, 133),
        child: GestureDetector(
          onTap: () {
            setState(() {
              // Cambiar el estado de la imagen
              isImageExpanded = !isImageExpanded;
            });
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: isImageExpanded ? 104.0 : 52.0, // Tamaño de la imagen
                  backgroundImage: const AssetImage('assets/images/Logo.jpeg'),
                ),
                const SizedBox(height: 25),
                const Text(
                  '★ Wallet Compass ★',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  '© UNA Developers',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card_rounded),
              title: const Text("Ver Tarjetas"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Home(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.portrait_rounded),
              title: const Text("Ver Identificación"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Identification(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.portrait_rounded),
              title: const Text("Ver Carnet Estudiantil"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Carnet(),
                ));
              },
            ),
          ],
        ),
      );
}
