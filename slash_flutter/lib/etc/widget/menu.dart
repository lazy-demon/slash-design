import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../object/ddoptions.dart';

class Menu extends ConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var list = [
    //   DDOptions(
    //     title: 'Users',
    //     route: ('/users-page'),
    //   ),
    //   DDOptions(
    //     title: 'Login',
    //     route: ('/login-page'),
    //   ),
    // ];

    return PopupMenuButton(
      onSelected: (route) => context.router.navigateNamed(route as String),
      itemBuilder: (_) => <PopupMenuEntry>[
        // for (var item in list)
        // PopupMenuItem(
        //   value: item.route,
        //   child: ListTile(
        //     trailing: const Icon(Icons.account_box),
        //     title: Text(item.title),
        //   ),
        // ),
      ],
    );
  }
}
