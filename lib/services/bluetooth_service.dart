import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

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

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}