import 'package:flutter/material.dart';

class HelpSection extends StatelessWidget {
  final String title;
  final List<HelpItem> items;

  const HelpSection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: items.map((item) => HelpItem(
        icon: item.icon,
        title: item.title,
        description: item.description,
      )).toList(),
    );
  }
}

class HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HelpItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}