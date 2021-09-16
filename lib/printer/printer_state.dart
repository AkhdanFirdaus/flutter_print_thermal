part of 'printer_provider.dart';

class PrinterState extends Equatable {
  final List<BluetoothInfo> pairedDevices;
  final String? macAddress;
  final PrinterEvent status;
  final bool isLoading;
  final String? failedMessage;

  PrinterState({
    this.pairedDevices = const [],
    this.macAddress,
    this.status = PrinterEvent.idle,
    this.isLoading = false,
    this.failedMessage,
  });

  PrinterState copyWith({
    List<BluetoothInfo>? pairedDevices,
    PrinterEvent? status,
    String? macAddress,
    bool? isLoading,
    String? failedMessage,
  }) {
    return PrinterState(
      pairedDevices: pairedDevices ?? this.pairedDevices,
      status: status ?? this.status,
      macAddress: macAddress ?? this.macAddress,
      isLoading: isLoading ?? this.isLoading,
      failedMessage: failedMessage ?? this.failedMessage,
    );
  }

  PrinterState startLoading() => copyWith(isLoading: true);
  PrinterState stopLoading() => copyWith(isLoading: false);
  PrinterState failed(String message) => copyWith(failedMessage: message);

  PrinterState connect(String macAddress) => copyWith(
        status: PrinterEvent.connected,
        macAddress: macAddress,
      );

  PrinterState disconnect() => copyWith(
        status: PrinterEvent.disconnect,
        macAddress: null,
      );

  PrinterState available() => copyWith(status: PrinterEvent.available);
  PrinterState notAvailable() => copyWith(status: PrinterEvent.notAvailable);

  PrinterState reset() => copyWith(
        status: PrinterEvent.idle,
        macAddress: null,
      );

  bool get isFailed => failedMessage != null;
  bool get isConnected => status == PrinterEvent.connected;
  bool get readyToConnect => status == PrinterEvent.available;

  @override
  List<Object?> get props =>
      [pairedDevices, macAddress, status, isLoading, failedMessage];
}
