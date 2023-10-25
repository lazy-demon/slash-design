import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../object/ddoptions.dart';
// import '../provider/user.dart';

class NDrawer extends ConsumerWidget {
  const NDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var name = ref.read(userProvider).value!.displayName ?? "Welcome";

    // var list = [
    //   DDOptions(
    //     title: 'Users',
    //     route: ('/users'),
    //   ),
    //   DDOptions(
    //     title: 'Login',
    //     route: ('/login'),
    //   ),
    // ];

    return Drawer(
      child: ListView(
          // padding: EdgeInsets.zero,
          // children: [
          //   UserAccountsDrawerHeader(
          //     currentAccountPicture: CircleAvatar(
          //       backgroundImage:
          //           NetworkImage('https://i.pravatar.cc/300?u=name$name'),
          //     ),
          //     accountEmail: const Text("email!"),
          //     accountName: Text(
          //       name,
          //       style: const TextStyle(fontSize: 20.0),
          //     ),
          //     decoration: const BoxDecoration(
          //       color: Colors.black87,
          //     ),
          //   ),
          //   ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: list.length,
          //     itemBuilder: (_, index) => ListTile(
          //       leading: const Icon(Icons.supervised_user_circle),
          //       title: Text(
          //         list[index].title,
          //         style: const TextStyle(fontSize: 24.0),
          //       ),
          //       onTap: () => Navigator.restorablePushNamed(
          //         context,
          //         list[index].route,
          //       ),
          //     ),
          //   ),
          //   const Divider(
          //     height: 10,
          //     thickness: 1,
          //   ),
          // ],
          ),
    );
  }
}
