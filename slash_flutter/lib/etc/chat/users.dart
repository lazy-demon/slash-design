import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../../router/router.dart';
import '../../../router/router.gr.dart';
import '../../scaffolding.dart';

@RoutePage()
class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  void _handlePressed(types.User otherUser, BuildContext context) async {
    await FirebaseChatCore.instance
        .createRoom(otherUser)
        .then((value) => context.router.push(ChatRoute(room: value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffolding(
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];

              return ListTile(
                leading: const CircleAvatar(
                    child: Icon(Icons.account_circle_outlined)),
                // Image.network(user.imageUrl ?? 'https://i.pravatar.cc/300'), convert to CanvasKit
                onTap: () => _handlePressed(user, context),
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.createdAt.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
