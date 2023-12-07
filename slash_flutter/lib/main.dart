import 'package:flutter/material.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';
import 'package:slash_client/slash_client.dart';
import 'package:slash_flutter/page/sign_in.dart';
import 'package:slash_flutter/src/service/serverpod_client.dart';
import 'package:slash_flutter/src/widget/scaffolding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeServerpodClient();
  await sessionManager.initialize();

  runApp(const Slash());
}

class Slash extends StatelessWidget {
  const Slash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slash Design',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Serverpod Example'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return sessionManager.isSignedIn
        ? const _ConnectionPage()
        : const SignInPage();
  }
}

class _ConnectionPage extends StatefulWidget {
  const _ConnectionPage();

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<_ConnectionPage> {
  List<Channel>? _channels;

  bool _connecting = false;

  final Map<String, ChatController> _chatControllers = {};

  @override
  void initState() {
    super.initState();

    // Starts listening to changes in the websocket connection.

    client.addStreamingConnectionStatusListener(_changedConnectionStatus);

    _connect();
  }

  @override
  void dispose() {
    super.dispose();

    client.removeStreamingConnectionStatusListener(_changedConnectionStatus);

    _disposeChatControllers();
  }

  void _disposeChatControllers() {
    for (var chatController in _chatControllers.values) {
      chatController.dispose();
    }

    _chatControllers.clear();
  }

  Future<void> _connect() async {
    setState(() {
      _channels = null;
      _connecting = true;

      _disposeChatControllers();
    });

    try {
      _channels = await client.channels.getChannels();

      await client.openStreamingConnection();

      for (var channel in _channels!) {
        var controller = ChatController(
          channel: channel.channel,
          module: client.modules.chat,
          sessionManager: sessionManager,
        );

        _chatControllers[channel.channel] = controller;

        controller.addConnectionStatusListener(_chatConnectionStatusChanged);
      }
    } catch (e) {
      setState(() {
        _channels = null;
        _connecting = false;
      });

      return;
    }
  }

  void _changedConnectionStatus() {
    setState(() {});
  }

  void _chatConnectionStatusChanged() {
    if (_channels == null || _channels!.isEmpty) {
      setState(() {
        _channels = null;
        _connecting = false;
      });

      return;
    }

    var numJoinedChannels = 0;

    for (var chatController in _chatControllers.values) {
      if (chatController.joinedChannel) {
        numJoinedChannels += 1;
      } else if (chatController.joinFailed) {
        setState(() {
          _channels = null;
          _connecting = false;
        });

        return;
      }
    }

    if (numJoinedChannels == _chatControllers.length) {
      setState(() {
        _connecting = false;
      });
    }
  }

  void _reconnect() {
    if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.disconnected) {
      _connect();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connecting) {
      return const Center(
          child: SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(),
      ));
    } else if (_channels == null ||
        client.streamingConnectionStatus ==
            StreamingConnectionStatus.disconnected) {
      return Scaffolding(
          body: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to connect.'),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: _reconnect,
              child: const Text('Try Again'),
            ),
          )
        ],
      )));
    } else {
      return const MainPage(
        title: '',
      );
    }
  }
}
