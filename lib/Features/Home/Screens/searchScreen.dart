import 'package:chat_app/Core/TypeDef/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Core/Common/error_text.dart';
import '../../../Core/Common/loader.dart';
import '../../../Core/Constant/other_constant.dart';
import '../../../Models/user_model.dart';
import '../../Auth/Controller/auth_controller.dart';
import '../Controller/userCon.dart';

class SearchUserDelegate extends SearchDelegate {
  final WidgetRef ref;
  final SearchTypes searchTypes;
  SearchUserDelegate({required this.searchTypes, required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final loggedUser = ref.watch(userProvider)!;
    void goToChatScreen(BuildContext context, UserModel userModel) {
      // to pop the previous screen
      Navigator.pop(context);
      // to push to next screen
      Routemaster.of(context)
          .push('/user-chat-page/${userModel.name}/${userModel.uid}');
    }

    if (searchTypes == SearchTypes.user) {
      return ref.watch(searchUsersProvider(query)).when(
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];
                // print(user.myUsers);

                if (data.isEmpty) {
                  return const Center(child: Text("No User found"));
                }
                return ListTile(
                  title: Text(
                    user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 1,
                  ),
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  trailing: loggedUser.myUsers.contains(user.uid)
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.mainColor,
                          ),
                          onPressed: () {
                            goToChatScreen(context, user);
                          },
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            // color: Constants.mainColor,
                            child: Center(
                              child:
                                  Icon(Icons.chat, color: Constants.whiteColor),
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            // // to send the request to user to add
                            ref
                                .read(userControllerProvider.notifier)
                                .requestUserToAdd(loggedUser.uid, user.uid);
                            print(loggedUser.uid);
                            // print(user.uid);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Constants.mainColor,
                              elevation: 2,
                              backgroundColor: Constants.mainColor),
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                );
              },
            ),
            error: (error, stackTrace) =>
                ErrorText(errorMessage: error.toString()),
            loading: () => const Loader(),
          );
    } else {
      return Container();
    }
  }
}
