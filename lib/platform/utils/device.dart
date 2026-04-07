
import "package:bluetooth_print/bluetooth_print_model.dart";

class PrinterDBluetoothDevice extends BluetoothDevice {
  PrinterDBluetoothDevice({required String name, required String address})
      : super(name: name, address: address);
}


class BluetoothDevice {
  String? name;
  String? address;
  int? type;
  bool? connected;

  BluetoothDevice({
    this.name,
    this.address,
    this.type,
    this.connected,
  });
}
