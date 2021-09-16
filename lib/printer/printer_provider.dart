import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

part 'printer_model.dart';
part 'printer_state.dart';

enum PrinterEvent { connected, disconnect, idle, available, notAvailable }

final printerProvider =
    StateNotifierProvider<PrinterModel, PrinterState>((ref) {
  return PrinterModel(PrinterState());
});
