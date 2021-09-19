import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:print_app/printer/printer_provider.dart';

class PrinterPage extends HookConsumerWidget {
  const PrinterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final state = ref.watch(printerProvider);
    final notifier = ref.read(printerProvider.notifier);
    final selectedDevice = useState<String>('');

    return Scaffold(
      appBar: AppBar(
        title: Text("Printer Settings"),
        actions: [
          IconButton(
            onPressed: () {
              notifier.refresh();
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                if (state.isLoading) {
                  return SpinKitRotatingCircle(
                    color: Colors.purple,
                    size: 30,
                  );
                }
                if (state.isNotAvailable) {
                  return InkWell(
                    onTap: () {
                      notifier.refresh();
                    },
                    child: Center(child: Text(state.message!)),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.pairedDevices.length,
                  itemBuilder: (_, index) {
                    final device = state.pairedDevices[index];
                    return ListTile(
                      onTap: () {
                        selectedDevice.value =
                            selectedDevice.value == device.macAdress
                                ? ''
                                : device.macAdress;
                      },
                      leading: device.macAdress == state.macAddress
                          ? Chip(
                              label: Text("Connected"),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            )
                          : null,
                      title: Text(device.name),
                      subtitle: Text(device.macAdress),
                      trailing: selectedDevice.value == device.macAdress
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                    );
                  },
                );
              }),
            ),
            Divider(),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                if (state.isConnected)
                  ElevatedButton.icon(
                    onPressed: () async {
                      notifier.template.printWithoutPackage('helloworld', '4');
                    },
                    icon: Icon(Icons.print),
                    label: Text("Test"),
                  ),
                if (state.isConnected)
                  ElevatedButton(
                    onPressed: () async {
                      await notifier.disconnect();
                      selectedDevice.value = '';
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: state.isConnecting
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Disconnect"),
                  ),
                if (!state.isConnected)
                  ElevatedButton(
                    onPressed: state.isAvailable && selectedDevice.value != ''
                        ? () async {
                            await notifier.connect(selectedDevice.value);
                          }
                        : null,
                    child: state.isConnecting
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Connect"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
