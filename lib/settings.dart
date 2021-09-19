import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:print_app/printer/printer_provider.dart';

class Settings extends HookWidget {
  Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          controller: scrollController,
          children: [
            Consumer(builder: (context, ref, widget) {
              final state = ref.watch(printerProvider);
              return ListTile(
                onTap: () => Navigator.pushNamed(context, '/printer-settings'),
                leading: Icon(
                  Icons.print,
                  color: (() {
                    if (state.isConnected) {
                      return Colors.green;
                    }
                    if (state.isNotAvailable) {
                      return Colors.red;
                    }
                  })(),
                ),
                title: Text("Printer Setting"),
                trailing: Icon(Icons.chevron_right_rounded),
              );
            }),
          ],
        ),
      ),
    );
  }
}
