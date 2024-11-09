import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  void _launchURL() async {
    final Uri url = Uri.parse('https://leoncyriac.me');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: _launchURL,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
            ),
            children: const [
              TextSpan(text: 'Made with '),
              TextSpan(
                text: '♥',
                style: TextStyle(color: Colors.red),
              ),
              TextSpan(text: ' by '),
              TextSpan(
                text: 'harshit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(text: ' (leoncyriac.me)'),
            ],
          ),
        ),
      ),
    );
  }
}