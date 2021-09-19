part of 'printer_provider.dart';

class PrinterState extends Equatable {
  final List<BluetoothInfo> pairedDevices;
  final String? macAddress;
  final PrinterEvent status;
  final bool isLoading;
  final bool isConnecting;
  final String? message;

  PrinterState({
    this.pairedDevices = const [],
    this.macAddress,
    this.status = PrinterEvent.notAvailable,
    this.isLoading = false,
    this.isConnecting = false,
    this.message,
  });

  PrinterState copyWith({
    List<BluetoothInfo>? pairedDevices,
    PrinterEvent? status,
    String? macAddress,
    bool? isLoading,
    bool? isConnecting,
    String? message,
  }) {
    return PrinterState(
      pairedDevices: pairedDevices ?? this.pairedDevices,
      status: status ?? this.status,
      macAddress: macAddress ?? this.macAddress,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }

  PrinterState startLoading() => copyWith(isLoading: true);
  PrinterState stopLoading() => copyWith(isLoading: false);
  PrinterState startConnecting() => copyWith(isConnecting: true);
  PrinterState stopConnecting() => copyWith(isConnecting: false);

  PrinterState failed(String message) => copyWith(
        status: PrinterEvent.notAvailable,
        message: message,
      );

  PrinterState available(String message, List<BluetoothInfo> devices) =>
      copyWith(
        status: isConnected ? PrinterEvent.connected : PrinterEvent.available,
        message: message,
        pairedDevices: devices,
      );

  PrinterState connect(String macAddress) {
    Hive.box<String?>('settingsBox').put('printerAddress', macAddress);
    return copyWith(
      status: PrinterEvent.connected,
      macAddress: macAddress,
    );
  }

  PrinterState disconnect() {
    Hive.box<String?>('settingsBox').delete('printerAddress');
    return copyWith(
      status: PrinterEvent.available,
      macAddress: null,
    );
  }

  bool get isConnected =>
      status == PrinterEvent.connected && macAddress != null;
  bool get hasLocalAddress => macAddress != null;
  bool get isAvailable =>
      status == PrinterEvent.available &&
      message != null &&
      pairedDevices.isNotEmpty;
  bool get isNotAvailable =>
      status == PrinterEvent.notAvailable &&
      message != null &&
      pairedDevices.isEmpty;

  @override
  List<Object?> get props =>
      [pairedDevices, macAddress, status, isLoading, isConnecting, message];
}
