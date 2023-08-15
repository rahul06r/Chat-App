import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../Core/Common/error_text.dart';
import '../../../../Core/Common/loader.dart';
import '../../../../Core/Constant/other_constant.dart';
import '../../../../Models/user_model.dart';
import '../../Controller/userCon.dart';

class HomeChatScreen extends ConsumerStatefulWidget {
  const HomeChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends ConsumerState<HomeChatScreen> {
  void goToChatScreen(BuildContext context, UserModel userModel) {
    Routemaster.of(context)
        .push('/user-chat-page/${userModel.name}/${userModel.uid}');
  }

  void openEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(numberOfUserProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];
                // print(user.lastMessageTime);

                return Column(
                  children: [
                    ListTile(
                      onLongPress: () {
                        // delete from User
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Delete ${user.name}'),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref
                                          .watch(
                                              userControllerProvider.notifier)
                                          .deleteUserFromChatScreen(
                                              user.uid, users.uid, context);
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      title: Text(
                        user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                      ),
                      subtitle: user.lastMessageType == 'msg'
                          ? Text(
                              user.lastMessage!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                color: Constants.greenColor,
                              ),
                              maxLines: 1,
                            )
                          : user.lastMessageType == 'image'
                              ? const Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(
                                    Icons.image,
                                    color: Constants.greenColor,
                                  ))
                              : const Text('New Chat'),
                      leading: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                      onTap: () {
                        goToChatScreen(context, user);
                      },
                      trailing: user.lastMessageTime != null
                          ? Container(
                              width: MediaQuery.of(context).size.width * .16,
                              height: 33,
                              decoration: BoxDecoration(
                                  color: Constants.greenColor,
                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  DateFormat('hh:mm a')
                                      .format(user.lastMessageTime!),
                                  // Replace 'No time available' with the appropriate message
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              )

                                  // : SizedBox(),
                                  ),
                            )
                          : const SizedBox(),
                    ),
                    const Divider(
                      color: Colors.black54,
                    ),
                  ],
                );
              },
            );
          },
          error: (e, stackTrace) => ErrorText(errorMessage: e.toString()),
          loading: () => const Loader()),
    );
  }
}
