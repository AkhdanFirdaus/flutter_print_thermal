import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as imag;
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

part 'printer_model.dart';
part 'printer_state.dart';
part 'printer_template.dart';

enum PrinterEvent { connected, available, notAvailable }

final printerProvider =
    StateNotifierProvider<PrinterModel, PrinterState>((ref) {
  PrinterTemplate template = PrinterTemplate();
  return PrinterModel(
    PrinterState(),
    template,
  );
});
