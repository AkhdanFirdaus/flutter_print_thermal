part of 'printer_provider.dart';

class PrinterTemplate {
  Future<void> printTest() async {
    List<int> ticket = await testTicket();
    final result = await PrintBluetoothThermal.writeBytes(ticket);
    print("impresion $result");
  }

  Future<void> printString() async {
    String enter = '\n';
    await PrintBluetoothThermal.writeBytes(enter.codeUnits);
    //size of 1-5
    String text = "Hello";
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 1, text: text));
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 2, text: text + " size 2"));
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 3, text: text + " size 3"));
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load('assets/logo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    final image = imag.decodeImage(bytesImg);
    // Using `ESC *`
    bytes += generator.image(image!);

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
        styles: PosStyles());
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    bytes += generator.text(
      'Special 2: blåbærgrød',
      styles: PosStyles(codeTable: 'CP1252'),
    );

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    //barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printWithoutPackage(String customText, String customSize) async {
    String text = customText.toString() + "\n";
    bool result = await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: int.parse(customSize), text: text));
    print("status print result: $result");
  }
}
