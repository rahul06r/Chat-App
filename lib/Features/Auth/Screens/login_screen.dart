import 'package:chat_app/Core/Common/signInButton.dart';
import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/Common/loader.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Chatter",
                  style: TextStyle(
                    fontSize: 30,
                    // fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontFamily: 'CaprasimoRegular',
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Constants.logopath,
                    height: 400,
                  ),
                ),
                const SizedBox(height: 20),
                const SignInButton(),
                // const ResponsiveW(child: SignInButton()),
              ],
            ),
    );
  }
}
