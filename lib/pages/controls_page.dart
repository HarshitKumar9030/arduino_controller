import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/wasd_controller.dart';
import '../widgets/control_button.dart';

class ControlsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WASDController(
          onDirectionPressed: (direction) {
            bluetoothService.sendCommand(direction);
          },
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ControlButton(
              label: 'A',
              onPressed: () => bluetoothService.sendCommand('A'),
            ),
            ControlButton(
              label: 'B',
              onPressed: () => bluetoothService.sendCommand('B'),
            ),
            ControlButton(
              label: 'X',
              onPressed: () => bluetoothService.sendCommand('X'),
            ),
            ControlButton(
              label: 'Y',
              onPressed: () => bluetoothService.sendCommand('Y'),
            ),
          ],
        ),
      ],
    );
  }
}