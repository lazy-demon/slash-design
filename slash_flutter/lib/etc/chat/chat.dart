import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart'
    hide Message, TextMessage, FileMessage, ImageMessage;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../scaffolding.dart';

@RoutePage()
class ChatPage extends ConsumerWidget {
  const ChatPage({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleAttachmentPressed() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // _handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // _handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void handleSendPressed(PartialText message) {
      FirebaseChatCore.instance.sendMessage(
        message,
        room.id,
      );
    }

    return Scaffolding(
      body: StreamBuilder<Room>(
        initialData: room,
        stream: FirebaseChatCore.instance.room(room.id),
        builder: (context, snapshot) {
          return StreamBuilder<List<Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              return SafeArea(
                bottom: false,
                child: Chat(
                  // isAttachmentUploading: isAttachmentUploading,
                  messages: snapshot.data ?? [],
                  onAttachmentPressed: handleAttachmentPressed,
                  // onMessageTap: handleMessageTap,
                  // onPreviewDataFetched: handlePreviewDataFetched,
                  onSendPressed: handleSendPressed,
                  user: User(
                    id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
