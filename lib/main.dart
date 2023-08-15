import 'package:chat_app/Core/Common/error_text.dart';
import 'package:chat_app/Core/Common/loader.dart';
import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:chat_app/Models/user_model.dart';
import 'package:chat_app/Router/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getUserData(User data, WidgetRef ref) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserdata(data.uid)
        .first;
    ref.watch(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangedProvider).when(
        data: (data) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Chat App',
              theme: ThemeData(
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Constants.whiteColor,
                  ),
                  iconTheme: IconThemeData(
                    color: Constants.whiteColor,
                  ),
                  color: Constants.mainColor,
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                buttonTheme: const ButtonThemeData(
                  buttonColor: Colors.purple,
                ),
              ),
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  getUserData(data, ref);
                  if (userModel != null) {
                    return loginRoute;
                  }
                }
                return loggedOutRoute;
              }),
              routeInformationParser: const RoutemasterParser(),
            ),
        error: (e, stackTrace) => ErrorText(errorMessage: e.toString()),
        loading: () => const Loader());
  }
}
