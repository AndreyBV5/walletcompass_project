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
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
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
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
