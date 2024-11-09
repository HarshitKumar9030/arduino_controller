import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('Controls'),
          children: [
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('W'),
              subtitle: Text('Move forward'),
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('A'),
              subtitle: Text('Move left'),
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('S'),
              subtitle: Text('Move backward'),
            ),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text('D'),
              subtitle: Text('Move right'),
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('A, B, X, Y'),
              subtitle: Text('Additional control buttons'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Audio Transmission'),
          children: [
            ListTile(
              title: Text('Recording'),
              subtitle: Text('Press the "Start Recording" button to begin recording audio. Press "Stop Recording" to end the recording and send it to the Arduino device.'),
            ),
            ListTile(
              title: Text('Playback'),
              subtitle: Text('Press the "Play Last Recording" button to listen to the most recently recorded audio.'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Bluetooth Connection'),
          children: [
            ListTile(
              title: Text('Connecting'),
              subtitle: Text('Press the Bluetooth icon in the bottom right corner to connect to an Arduino device. Select your device from the list of available devices.'),
            ),
            ListTile(
              title: Text('Disconnecting'),
              subtitle: Text('Go to the Settings page and turn off the Bluetooth Connection switch to disconnect from the current device.'),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('Troubleshooting'),
          children: [
            ListTile(
              title: Text('Connection Issues'),
              subtitle: Text('If you\'re having trouble connecting, make sure your Arduino device is powered on and in range. Try restarting both the app and the Arduino device.'),
            ),
            ListTile(
              title: Text('Audio Problems'),
              subtitle: Text('If audio transmission isn\'t working, check your device\'s microphone permissions and ensure the Arduino device is set up to receive audio data.'),
            ),
          ],
        ),
      ],
    );
  }
}