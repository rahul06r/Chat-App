import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/Common/error_text.dart';
import '../../../Core/Common/loader.dart';
import '../../../Core/Common/showSnackBar.dart';
import '../../Home/Controller/userCon.dart';
import 'dart:io';

class EditScreenProfileUser extends ConsumerStatefulWidget {
  final String id;
  const EditScreenProfileUser({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditScreenProfileUserState();
}

class _EditScreenProfileUserState extends ConsumerState<EditScreenProfileUser> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    textEditingController =
        TextEditingController(text: ref.read(userProvider)!.name);
    print(textEditingController.text);
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  File? profileImage;
  Future<void> selcteProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileImage = File(res.files.first.path!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Profile'),
      ),
      body: ref.watch(mainUserProvider(widget.id)).when(
          data: (data) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                            onTap: () {
                              print('pressed');
                              selcteProfileImage();
                            },
                            child: profileImage != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(profileImage!),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        NetworkImage(data.profilePic),
                                  )),
                        // edit button
                        Positioned(
                          right: -40,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              print('pressed');
                              selcteProfileImage();
                            },
                            child: SizedBox(
                              width: 35,
                              child: FractionallySizedBox(
                                heightFactor: 0.3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constants.mainColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      print('pressed');
                                      // selcteProfileImage();
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Constants.whiteColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // text name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    child: TextField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                        ),
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.mainColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
          error: (e, stacktrace) => ErrorText(errorMessage: e.toString()),
          loading: () => const Loader()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // save the changes
          ref.watch(userControllerProvider.notifier).editUserProfile(
                name: textEditingController.text,
                context: context,
                profileImage: profileImage,
              );
          print("floating button${textEditingController.text}");
        },
        backgroundColor: Constants.mainColor,
        child: const Icon(
          Icons.save,
          color: Constants.whiteColor,
        ),
      ),
    );
  }
}
