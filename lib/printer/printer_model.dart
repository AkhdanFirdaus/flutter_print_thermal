part of 'printer_provider.dart';

class PrinterModel extends StateNotifier<PrinterState> {
  PrinterModel(PrinterState state) : super(state) {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    if (!result) state = state.notAvailable();
  }

  Future<void> getBluetooths() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    if (listResult.isEmpty) {
      state = state.failed(
        "There are no bluetoohs linked, go to settings and link the printer",
      );
    } else {
      state = state.available();
    }

    state = state.copyWith(pairedDevices: listResult);
  }

  Future<void> connect(String mac) async {
    if (!state.isLoading) {
      state = state.startLoading();
      final result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (result) state = state.connect(mac);
      state = state.stopLoading();
    }
  }

  Future<void> disconnect() async {
    if (!state.isLoading) {
      state = state.startLoading();
      final bool status = await PrintBluetoothThermal.disconnect;
      if (status) state = state.disconnect();
      state = state.stopLoading();
    }
  }
}
