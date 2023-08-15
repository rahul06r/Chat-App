import 'package:chat_app/Features/Auth/Screens/login_screen.dart';
import 'package:chat_app/Features/Home/Screens/home_Screen.dart';
import 'package:chat_app/Features/Home/Screens/requestedUserPage.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../Features/Chats/Screens/personal_chat_screen.dart';
import '../Features/User_Screen/Screen/edit_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loginRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: HomePageScreen(),
      ),
  '/user-chat-page/:name/:id': (route) => MaterialPage(
        child: PersonalChatScreen(
          name: route.pathParameters['name']!,
          id: route.pathParameters['id']!,
        ),
      ),

  //
  '/user-requested-page': ((route) => const MaterialPage(
        child: Requesteduserpage(),
      )),

  '/user_profile_edit/:id': (route) => MaterialPage(
        child: EditScreenProfileUser(
          id: route.pathParameters['id']!,
        ),
      ),
});




//  check when both users chat then scrolling is working or not