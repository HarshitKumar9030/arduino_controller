import 'package:flutter/material.dart';

class WASDController extends StatelessWidget {
  final Function(String) onDirectionPressed;

  const WASDController({Key? key, required this.onDirectionPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 60,
            child: _buildDirectionButton('W', Icons.arrow_upward),
          ),
          Positioned(
            bottom: 0,
            left: 60,
            child: _buildDirectionButton('S', Icons.arrow_downward),
          ),
          Positioned(
            left: 0,
            top: 60,
            child: _buildDirectionButton('A', Icons.arrow_back),
          ),
          Positioned(
            right: 0,
            top: 60,
            child: _buildDirectionButton('D', Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(String direction, IconData icon) {
    return GestureDetector(
      onTapDown: (_) => onDirectionPressed(direction),
      onTapUp: (_) => onDirectionPressed('STOP'),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}