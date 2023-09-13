import 'package:serverpod/serverpod.dart';

// After adding or modifying an endpoint, you will need to run
// `serverpod generate` to update the server and client code.
class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
}
