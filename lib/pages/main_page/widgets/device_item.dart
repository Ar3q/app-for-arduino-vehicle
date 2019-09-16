import 'package:app_for_arudino_vehicle/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceItem extends StatelessWidget {
  final BluetoothDevice bluetoothDevice;

  const DeviceItem({@required this.bluetoothDevice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Name: ' + bluetoothDevice.name,
                ),
                Text(
                  'Address: ' + bluetoothDevice.address,
                ),
              ],
            ),
            Visibility(
              visible: !bluetoothDevice.isBonded,
              child: RaisedButton(
                child: Text('Pair'),
                onPressed: () async {
                  print('Pair pressed');
                  bool paired = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(bluetoothDevice.address);
                  print('paired ' + paired.toString());
                },
              ),
            ),
            Visibility(
              visible: !bluetoothDevice.isConnected && bluetoothDevice.isBonded,
              child: RaisedButton(
                child: Text('Connect'),
                onPressed: () async {
                  print('Connect pressed');
                  final bloc = BlocProvider.of<ConnectedDeviceBloc>(context);
                  bloc.dispatch(ConnectToDevice(device: bluetoothDevice));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
