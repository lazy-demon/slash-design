import 'package:flutter/material.dart';

class Scaffolding extends StatelessWidget {
  const Scaffolding({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.blue,
      ),
      body: body,
    );
  }
}
