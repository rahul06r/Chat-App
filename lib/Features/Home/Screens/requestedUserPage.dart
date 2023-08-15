import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/Common/error_text.dart';
import '../../../Core/Common/loader.dart';
import '../Controller/userCon.dart';

class Requesteduserpage extends ConsumerStatefulWidget {
  const Requesteduserpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequesteduserpageState();
}

class _RequesteduserpageState extends ConsumerState<Requesteduserpage> {
  @override
  Widget build(BuildContext context) {
    final userS = ref.watch(userProvider)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Requested List',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ref.watch(getRequestedUsersProvider).when(
            data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = data[index];
                    return Card(
                      color: Constants.mainColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(user.profilePic),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Constants.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .watch(userControllerProvider.notifier)
                                        .deleteUserFromRequestedUser(
                                            userS.uid, user.uid, context);
                                    // print(user.uid);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  onPressed: () {
                                    ref
                                        .watch(userControllerProvider.notifier)
                                        .addUser(userS.uid, user.uid);
                                    print(user.uid);
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
            error: (e, stackTrace) => ErrorText(errorMessage: e.toString()),
            loading: () => const Loader()),
      ),
    );
  }
}
