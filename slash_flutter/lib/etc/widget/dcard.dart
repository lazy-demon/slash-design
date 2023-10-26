import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayCard extends ConsumerWidget {
  const DisplayCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: Column(children: <Widget>[
      ListTile(
        leading: const Icon(Icons.arrow_drop_down_circle),
        title: const Text('Card title 1'),
        subtitle: Text(
          'Secondary Text',
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
      ),
      Container(
        height: 124,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      ButtonBar(
        alignment: MainAxisAlignment.start,
        children: [
          TextButton(
            // textColor: const Color(0xFF6200EE),
            onPressed: () {
              // Perform some action
            },
            child: const Text('ACTION 1'),
          ),
          TextButton(
            // textColor: const Color(0xFF6200EE),
            onPressed: () {
              // Perform some action
            },
            child: const Text('ACTION 2'),
          )
        ],
      )
    ]));
  }
}
