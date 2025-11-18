import 'package:fasting_app/home/home.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const NavBar({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.schedule,
            label: 'Fast',
            onPressed: () => onTabSelected(0),
          ),
          NavBarItem(
            icon: Icons.settings,
            label: 'Settings',
            onPressed: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}
