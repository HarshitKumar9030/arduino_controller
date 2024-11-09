import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'services/bluetooth_service.dart';
import 'services/audio_service.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothService()),
        ChangeNotifierProvider(create: (_) => AudioService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arduino Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

// HomePage
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedMenu = 'Controls';

  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Arduino Controller'),
        actions: [
          StatusButton(isConnected: bluetoothService.isConnected),
        ],
      ),
      body: Column(
        children: [
          MenuSelector(
            selectedMenu: selectedMenu,
            onMenuSelected: (menu) {
              setState(() {
                selectedMenu = menu;
              });
            },
          ),
          Expanded(
            child: _buildSelectedMenu(),
          ),
          CustomFooter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBluetoothDialog(context),
        child: Icon(bluetoothService.isConnected ? Icons.bluetooth_connected : Icons.bluetooth),
        tooltip: bluetoothService.isConnected ? 'Disconnect' : 'Connect to device',
      ),
    );
  }

  Widget _buildSelectedMenu() {
    switch (selectedMenu) {
      case 'Controls':
        return ControlsPage();
      case 'Audio':
        return AudioPage();
      case 'Settings':
        return SettingsPage();
      case 'Help':
        return HelpPage();
      default:
        return Container();
    }
  }

  void _showBluetoothDialog(BuildContext context) async {
    final bluetoothService = Provider.of<BluetoothService>(context, listen: false);
    if (bluetoothService.isConnected) {
      await bluetoothService.disconnect();
    } else {
      final BluetoothDevice? selectedDevice = await showDialog<BluetoothDevice>(
        context: context,
        builder: (BuildContext context) {
          return BluetoothDeviceListDialog();
        },
      );

      if (selectedDevice != null) {
        await bluetoothService.connectToDevice(selectedDevice);
      }
    }
  }
}

// StatusButton
class StatusButton extends StatelessWidget {
  final bool isConnected;

  StatusButton({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        label: Text(isConnected ? 'Connected' : 'Disconnected'),
        backgroundColor: isConnected ? Colors.green : Colors.red,
      ),
    );
  }
}

// MenuSelector
class MenuSelector extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuSelected;

  MenuSelector({required this.selectedMenu, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
        ),
      ),
    );
  }
}

// ControlsPage
class ControlsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WASDController(onDirectionPressed: (direction) {
          bluetoothService.sendCommand(direction);
        }),
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ControlButton(label: 'A', onPressed: () => bluetoothService.sendCommand('A')),
            ControlButton(label: 'B', onPressed: () => bluetoothService.sendCommand('B')),
            ControlButton(label: 'X', onPressed: () => bluetoothService.sendCommand('X')),
            ControlButton(label: 'Y', onPressed: () => bluetoothService.sendCommand('Y')),
          ],
        ),
      ],
    );
  }
}

// WASDController
class WASDController extends StatelessWidget {
  final Function(String) onDirectionPressed;

  WASDController({required this.onDirectionPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDirectionButton('W', Icons.arrow_upward),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDirectionButton('A', Icons.arrow_back),
            SizedBox(width: 50),
            _buildDirectionButton('D', Icons.arrow_forward),
          ],
        ),
        _buildDirectionButton('S', Icons.arrow_downward),
      ],
    );
  }

  Widget _buildDirectionButton(String direction, IconData icon) {
    return ElevatedButton(
      onPressed: () => onDirectionPressed(direction),
      child: Icon(icon),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}

// ControlButton
class ControlButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  ControlButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}

// AudioPage
class AudioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: bluetoothService.isConnected
                ? () {
                    if (audioService.isRecording) {
                      audioService.stopRecording();
                    } else {
                      audioService.startRecording();
                    }
                  }
                : null,
            child: Text(audioService.isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
          SizedBox(height: 20),
          Text(
            bluetoothService.isConnected
                ? 'Audio transmission enabled'
                : 'Connect to a device to enable audio transmission',
            style: TextStyle(color: bluetoothService.isConnected ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}

// SettingsPage
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bluetoothService = Provider.of<BluetoothService>(context);

    return ListView(
      children: [
        ListTile(
          title: Text('Bluetooth Connection'),
          subtitle: Text(bluetoothService.isConnected ? 'Connected' : 'Disconnected'),
          trailing: Switch(
            value: bluetoothService.isConnected,
            onChanged: (value) async {
              if (value) {
                final BluetoothDevice? selectedDevice = await showDialog<BluetoothDevice>(
                  context: context,
                  builder: (BuildContext context) {
                    return BluetoothDeviceListDialog();
                  },
                );
                if (selectedDevice != null) {
                  await bluetoothService.connectToDevice(selectedDevice);
                }
              } else {
                await bluetoothService.disconnect();
              }
            },
          ),
        ),
        ListTile(
          title: Text('Audio Quality'),
          subtitle: Text('High'),
          onTap: () {
            // Implement audio quality selection
          },
        ),
        ListTile(
          title: Text('Command Customization'),
          subtitle: Text('Customize button commands'),
          onTap: () {
            // Implement command customization page
          },
        ),
      ],
    );
  }
}

// HelpPage
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}

// CustomFooter
class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Made with ♥ by harshit (leoncyriac.me)',
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// BluetoothDeviceListDialog
class BluetoothDeviceListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a device'),
      content: Container(
        width: double.maxFinite,
        child: FutureBuilder(
          future: FlutterBluetoothSerial.instance.getBondedDevices(),
          builder: (context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No paired devices found'));
            }

            return ListView(
              shrinkWrap: true,
              children: snapshot.data!.map((device) {
                return ListTile(
                  title: Text(device.name ?? "Unknown device"),
                  subtitle: Text(device.address),
                  onTap: () {
                    Navigator.of(context).pop(device);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

// BluetoothService
class BluetoothService extends ChangeNotifier {
  BluetoothConnection? connection;
  bool isConnected = false;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      isConnected = true;
      notifyListeners();
      print('Connected to the device');
    } catch (exception) {
      print('Cannot connect, exception occurred: $exception');
    }
  }

  void sendCommand(String command) {
    connection?.output.add(Uint8List.fromList(command.codeUnits));
  }

  Future<void> disconnect() async {
    await connection?.close();
    isConnected = false;
    notifyListeners();
  }
}

// AudioService
class AudioService extends ChangeNotifier {
  bool isRecording = false;

  void startRecording() {
    // Implement start recording logic
    isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    // Implement stop recording logic
    isRecording = false;
    notifyListeners();
  }
}