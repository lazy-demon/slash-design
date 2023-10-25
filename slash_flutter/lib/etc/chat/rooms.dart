import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../../router/router.dart';
import '../../../router/router.gr.dart';
import '../../scaffolding.dart';

@RoutePage()
class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffolding(
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final room = snapshot.data![index];

              return ListTile(
                onTap: () => context.router.push(ChatRoute(room: room)),
                title: Text(room.id),
              );
            },
          );
        },
      ),
    );
  }
}
