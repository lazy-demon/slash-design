import 'package:flutter/material.dart';

class Scaffolding extends StatelessWidget {
  const Scaffolding({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    // var authStatus = ref.watch(authStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
        // actions: const [Menu()],
      ),
      // drawer: (authStatus is Authenticated) ? const NDrawer() : null,
      body: body,
      // floatingActionButton: FAB(),
    );
  }
}
