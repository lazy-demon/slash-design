import 'package:auto_route/auto_route.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../object/state/auth.dart';

@RoutePage()
class VerificationPage extends ConsumerWidget {
  const VerificationPage(this.resolver, this.router, {Key? key})
      : super(key: key);

  final NavigationResolver resolver;
  final StackRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmailVerificationScreen(
      actions: [
        EmailVerifiedAction(() {
          resolver.next(true);
        }),
        AuthCancelledAction((context) {
          FirebaseUIAuth.signOut(context: context);
          router.replaceNamed('/');
        }),
      ],
    );
  }
}
