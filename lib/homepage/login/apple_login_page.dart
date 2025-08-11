import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../theme/theme_color.dart';

class AppleLoginPage extends StatelessWidget {
  const AppleLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme_color_df,
        ),
        body: (Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: signInApple, child: const Text('apple'))
          ],
        )));
  }

  Future<void> signInApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential.email);
    print(credential.userIdentifier);
    print(credential.identityToken);
  }
}
