import 'package:flutter/material.dart';

class MenuSelector extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuSelected;

  const MenuSelector({
    Key? key,
    required this.selectedMenu,
    required this.onMenuSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMenuButton('Controls', Icons.gamepad),
          _buildMenuButton('Audio', Icons.mic),
          _buildMenuButton('Settings', Icons.settings),
          _buildMenuButton('Help', Icons.help),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label, IconData icon) {
    bool isSelected = selectedMenu == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: () => onMenuSelected(label),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}