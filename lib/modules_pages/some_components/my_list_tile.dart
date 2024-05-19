import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEdithPressed;
  final void Function(BuildContext)? onDeletePressed;

  const MyListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEdithPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          // Configurar opciones
          SlidableAction(
            onPressed: onEdithPressed,
            icon: Icons.edit_rounded,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),

          // Borrar opciones
          SlidableAction(
            onPressed: onDeletePressed,
            icon: Icons.delete_rounded,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ]),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.1), // Color y opacidad de la sombra
                spreadRadius: 1, // Cuánto se expande la sombra
                blurRadius: 1, // Desenfoque de la sombra
                offset:
                    const Offset(0, 3), // Desplazamiento de la sombra (x, y)
              ),
            ],
          ),
          child: ListTile(
            title: Text(title),
            trailing: Text(trailing, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
