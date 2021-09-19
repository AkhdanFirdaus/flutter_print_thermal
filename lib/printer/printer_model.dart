part of 'printer_provider.dart';

class PrinterModel extends StateNotifier<PrinterState> {
  PrinterModel(PrinterState state, this.template)
      : super(PrinterState(
          macAddress: Hive.box<String?>('settingsBox').get('printerAddress'),
        )) {
    refresh();
    check();
    PrintBluetoothThermal.connectionStatus.asStream().listen((event) async {
      final local = Hive.box<String?>('settingsBox').get('printerAddress');
      print("dari listener, status $event");
      print("dari listener, local = $local");
      if (!event && state.isAvailable) {
        print("dari listener, haslocal address");
        await connect(local!);
      }

      if (event && state.isAvailable && local != null) {
        state = state.connect(local);
      }
    });

    PrintBluetoothThermal.bluetoothEnabled.asStream().listen((event) async {
      final local = Hive.box<String?>('settingsBox').get('printerAddress');
      if (event && local != null) {
        await connect(local);
      }
    });
  }

  final PrinterTemplate template;

  Future<void> check() async {
    final status = await PrintBluetoothThermal.connectionStatus;
    final local = Hive.box<String?>('settingsBox').get('printerAddress');
    if (status && local != null) state = state.connect(local);
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    if (!result) state = state.failed('Bluetooth not enabled');
  }

  Future<void> getBluetooths() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    if (listResult.isEmpty) {
      state = state.failed(
        "There are no bluetooths linked, go to settings and link the printer",
      );
    } else {
      state = state.available('Linked device available', listResult);
    }
  }

  Future<void> init() async {
    await initPlatformState();
    await getBluetooths();
  }

  Future<void> refresh() async {
    if (!state.isLoading) {
      state = state.startLoading();
      await initPlatformState();
      await getBluetooths();
      await Future.delayed(const Duration(seconds: 1));
      state = state.stopLoading();
    }
  }

  Future<void> connect(String mac) async {
    if (!state.isConnecting) {
      state = state.startConnecting();
      final result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (result) state = state.connect(mac);
      state = state.stopConnecting();
    }
  }

  Future<void> disconnect() async {
    if (!state.isConnecting) {
      state = state.startConnecting();
      final bool status = await PrintBluetoothThermal.disconnect;
      if (status) state = state.disconnect();
      state = state.stopConnecting();
    }
  }
}
