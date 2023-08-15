import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  final isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
              fontSize: 18,
              letterSpacing: 1,
              color: Constants.whiteColor,
              // fontFamily: Constants.fontsUsed,
              fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Constants.mainColor,
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
