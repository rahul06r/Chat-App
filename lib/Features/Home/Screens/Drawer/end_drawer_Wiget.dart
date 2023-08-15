import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Auth/Controller/auth_controller.dart';
import '../../../../Models/user_model.dart';

class DrawerWigdet extends StatelessWidget {
  const DrawerWigdet({
    super.key,
    required this.user,
    required this.ref,
  });

  final UserModel user;
  final WidgetRef ref;

  void goToRequestedPage(BuildContext context, UserModel user) {
    Routemaster.of(context).push('/user-requested-page');
  }

  void goToEditUserPage(BuildContext context) {
    Routemaster.of(context).push('/user_profile_edit/${user.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 10),
          CircleAvatar(
            // maxRadius: 30,
            // minRadius: 10,
            radius: 40,
            backgroundImage: NetworkImage(user.profilePic),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "No of Users:${user.myUsers.length}",
          ),
          const SizedBox(height: 40),
          IconButton(
              onPressed: () {
                goToEditUserPage(context);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              )),

          const SizedBox(height: 40),
          //
          GestureDetector(
            onTap: () {
              goToRequestedPage(context, user);
            },
            child: Text(
              'User request no: ${user.requestedUsers.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          //
          const SizedBox(height: 40),
          const SizedBox(height: 40),
          IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logoutUser();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}
