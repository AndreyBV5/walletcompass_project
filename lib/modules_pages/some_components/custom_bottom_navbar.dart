import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Widget item;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.item,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: GestureDetector(
        onTap: () => onItemSelected(0),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color:
                    selectedIndex == 0 ? Colors.deepPurple : Colors.transparent,
              ),
            ),
          ),
          child: item,
        ),
      ),
    );
  }
}
