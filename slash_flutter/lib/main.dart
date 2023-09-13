import 'package:slash_client/slash_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Slash Design'),
    );
  }
}

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: 'initial text');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Slash Design"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await client.example.hello(controller.text);
                },
                child: const Text('Send to Server'),
              ),
            ),
            FutureBuilder<String>(
              future: client.example.hello(controller.value.text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('1');
                  return Center(child: Text(snapshot.data!));
                } else if (snapshot.hasError) {
                  print('2');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  print('3');
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
