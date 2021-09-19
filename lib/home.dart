import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:print_app/printer/printer_provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Page 1"),
              Consumer(builder: (context, ref, widget) {
                final state = ref.watch(printerProvider);
                return ElevatedButton.icon(
                  onPressed: state.isConnected
                      ? () async {
                          ref
                              .read(printerProvider.notifier)
                              .template
                              .printWithoutPackage('helloworld', '4');
                        }
                      : null,
                  icon: Icon(Icons.print),
                  label: Text("Test"),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
