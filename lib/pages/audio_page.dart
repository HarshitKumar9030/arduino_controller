import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';
import '../services/bluetooth_service.dart';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  double _volume = 1.0;
  String _quality = 'High';
  bool _isTransmitting = false;

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audio Controls',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text('Volume'),
                  Slider(
                    value: _volume,
                    onChanged: (value) {
                      setState(() => _volume = value);
                      audioService.setVolume(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _quality,
                    isExpanded: true,
                    items: ['Low', 'Medium', 'High'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _quality = newValue);
                        audioService.setQuality(newValue);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audio Transmission',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() => _isTransmitting = true);
                        audioService.startRecording();
                      },
                      onTapUp: (_) {
                        setState(() => _isTransmitting = false);
                        audioService.stopRecording();
                      },
                      onTapCancel: () {
                        setState(() => _isTransmitting = false);
                        audioService.stopRecording();
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isTransmitting ? Colors.red : Colors.blue,
                        ),
                        child: Icon(
                          _isTransmitting ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      _isTransmitting ? 'Recording...' : 'Press and hold to speak',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!bluetoothService.isConnected)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Connect to a Bluetooth device to enable audio transmission',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}