import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../services/audio_service.dart';
import './device_selection_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, String> _buttonCommands = {
    'A': 'LED_ON',
    'B': 'LED_OFF',
    'X': 'SERVO_LEFT',
    'Y': 'SERVO_RIGHT',
  };

  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);
    final audioService = Provider.of<AudioService>(context);

    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Bluetooth Connection'),
                subtitle: Text(bluetoothService.isConnected ? 'Connected' : 'Disconnected'),
                trailing: Switch(
                  value: bluetoothService.isConnected,
                  onChanged: (value) async {
                    if (value) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeviceSelectionPage()),
                      );
                      if (result != null) {
                        await bluetoothService.connectToDevice(result);
                      }
                    } else {
                      await bluetoothService.disconnect();
                    }
                  },
                ),
              ),
              if (bluetoothService.isConnected)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Connected to: HC-05'),
                ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Button Commands'),
                subtitle: Text('Customize control buttons'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _buttonCommands.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Command',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(text: entry.value),
                              onChanged: (value) {
                                setState(() {
                                  _buttonCommands[entry.key] = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Audio Settings'),
                subtitle: Text('Configure audio transmission'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Audio Quality',
                        border: OutlineInputBorder(),
                      ),
                      value: 'High',
                      items: ['Low', 'Medium', 'High'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          audioService.setQuality(newValue);
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Echo Cancellation'),
                      value: true,
                      onChanged: (bool value) {
                        // Implement echo cancellation toggle
                      },
                    ),
                    SwitchListTile(
                      title: Text('Noise Reduction'),
                      value: true,
                      onChanged: (bool value) {
                        // Implement noise reduction toggle
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}