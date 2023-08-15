import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Core/TypeDef/enums.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:chat_app/Features/Home/Screens/searchScreen.dart';
import 'package:chat_app/Models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'Drawer/end_drawer_Wiget.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  void goToChatScreen(BuildContext context, UserModel userModel) {
    Routemaster.of(context)
        .push('/user-chat-page/${userModel.name}/${userModel.uid}');
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  int _page = 1;
  void onChnagedPage(int page) {
    setState(() {
      _page = page;
    });
  }

  // var checkHttp = ' https://firebasestorage.googleapis.com';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      // endDrawer: SafeArea(
      //   child: DrawerWigdet(user: user, ref: ref),
      // ),
      appBar: AppBar(
        toolbarHeight: 80,
        titleSpacing: 30,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications,
                ),
              ],
            ),
          ),
          _page == 1
              ? IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchUserDelegate(
                        ref: ref,
                        searchTypes: SearchTypes.user,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                )
              : _page == 0
                  ? Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: SearchUserDelegate(
                                  ref: ref,
                                  searchTypes: SearchTypes.community,
                                ),
                              );
                            },
                            icon: const Icon(Icons.search)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.add))
                      ],
                    )
                  : const SizedBox(),
        ],
        title: const Text(
          "Chatter",
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1,
            color: Constants.whiteColor,
            fontFamily: Constants.fontsUsed,
          ),
        ),
      ),
      body: Constants.feedScreen[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Constants.whiteColor,
        backgroundColor: Constants.mainColor,
        onTap: onChnagedPage,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_2_rounded), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
