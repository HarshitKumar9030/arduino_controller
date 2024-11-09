import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/status_button.dart';
import '../widgets/menu_selector.dart';
import '../widgets/custom_footer.dart';
import './controls_page.dart';
import './audio_page.dart';
import './settings_page.dart';
import './help_page.dart';
import './device_selection_page.dart';

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
        onPressed: () async {
          if (!bluetoothService.isConnected) {
            final result = await showDialog(
              context: context,
              builder: (context) => BluetoothDialog(),
            );
            if (result != null) {
              await bluetoothService.connectToDevice(result);
            }
          } else {
            await bluetoothService.disconnect();
          }
        },
        child: Icon(
          bluetoothService.isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
        ),
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
}

class BluetoothDialog extends StatelessWidget {
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
                    Navigator.pop(context, device);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}