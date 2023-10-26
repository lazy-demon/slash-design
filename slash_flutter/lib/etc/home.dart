import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slash_design/object/state/auth.dart';

import '../scaffolding.dart';

// @RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffolding(
        body: Column(
      children: [
        //   ElevatedButton(
        //       onPressed: () =>
        //           ref.read(authStatusProvider.notifier).signInAnonymously(),
        //       child: const Text("login")),
        //   ElevatedButton(
        //       onPressed: () => ref.read(authStatusProvider.notifier).signOut(),
        //       child: const Text("logout"))
      ],
    ));
  }
}
