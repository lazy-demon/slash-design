// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slash_design/object/state/auth.dart';

// import 'package:flutter_lorem/flutter_lorem.dart';
// import 'package:fonq/logic/provider/user.dart';
// import '../../logic/provider/auth.dart';

class FAB extends ConsumerWidget {
  FAB({Key? key}) : super(key: key);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var todos = ref.read(authStatesProvider);

    var list = {
      // "login": () async {
      //   ref.read(authStatusProvider.notifier).signInAnonymously();
      //   // print(ref.read(userProvider).value);
      // },
      // "user": () async {
      // await FirebaseChatCore.instance.createUserInFirestore(
      //   User(
      //     firstName: ref.watch(authStatusProvider)!.email,
      //     lastName: 'Doe',
      //     id: ref.watch(authStatusProvider)!.uid,
      //     imageUrl: 'https://i.pravatar.cc/300',
      //   ),
      // );
      // },
      // "logout": () async {
      //   await ref.read().signOut();
      //   // context.router.replace(const LoginRoute());
      // },
      // "add": () async {
      //   await db.collection('products').add({
      //     'name': 'Product ${Random().nextInt(100)}',
      //     'price':
      //         double.parse((Random().nextDouble() * 100).toStringAsFixed(2)),
      //     'description': lorem(paragraphs: 1, words: 10),
      //   });
      // },
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        for (var item in list.keys)
          FloatingActionButton(
            onPressed: list[item],
            heroTag: item,
            child: Text(item),
          ),
      ],
    );
  }
}
