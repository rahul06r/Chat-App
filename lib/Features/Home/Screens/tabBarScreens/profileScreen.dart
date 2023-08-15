import 'dart:io';

import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../Core/Common/showSnackBar.dart';
import '../../../../Models/user_model.dart';
import '../../Controller/userCon.dart';

class ProfileSCreen extends ConsumerStatefulWidget {
  const ProfileSCreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileSCreenState();
}

class _ProfileSCreenState extends ConsumerState<ProfileSCreen> {
  late TextEditingController textEditingController;
  late var _isEditable;
  late var _isOpen;
  @override
  void initState() {
    textEditingController =
        TextEditingController(text: ref.read(userProvider)!.name);
    _isEditable = false;
    _isOpen = false;
    super.initState();
  }

  void save() {
    ref.watch(userControllerProvider.notifier).editUserProfile(
          name: textEditingController.text,
          context: context,
          profileImage: profileImage,
        );
  }

  void goToRequestedPage(BuildContext context, UserModel user) {
    Routemaster.of(context).push('/user-requested-page');
  }

  File? profileImage;
  Future<void> selcteProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileImage = File(res.files.first.path!);
        save();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                profileImage != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(profileImage!),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    splashColor: Constants.darkgreenColor,
                    onPressed: () {
                      if (kDebugMode) {
                        print("image select");
                      }
                      selcteProfileImage().then((value) =>
                          flutterToast(context, 'Profile photo updated'));
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 30,
                      color: Constants.balckColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // names
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 80,
                  // flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    child: TextField(
                      controller: textEditingController,
                      onSubmitted: (val) {
                        setState(() {
                          _isEditable = !_isEditable;
                        });
                        save();
                      },
                      autofocus: false,
                      readOnly: !_isEditable,
                      decoration: const InputDecoration(
                        // contentPadding: EdgeInsets.only(left: 20, bottom: 0),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.mainColor),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // icons for edit or save

                _isEditable
                    ? IconButton(
                        color: Constants.balckColor,
                        onPressed: () {
                          setState(() {
                            _isEditable = !_isEditable;
                          });
                          save();
                        },
                        icon: const Icon(
                          Icons.save_as,
                        ))
                    : IconButton(
                        color: Constants.balckColor,
                        onPressed: () {
                          setState(() {
                            _isEditable = !_isEditable;
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                        )),
                // user Request List
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 2,
              color: Constants.balckColor,
            ),
            ListTile(
              onTap: () {
                goToRequestedPage(context, user);
              },
              title: const Text(
                'Number of users requested',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  goToRequestedPage(context, user);
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 25,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Constants.balckColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: Constants.fontsUsed,
                    ),
                  ),
                  IconButton(
                      color: Constants.balckColor,
                      onPressed: () {
                        ref.read(authControllerProvider.notifier).logoutUser();
                      },
                      icon: const Icon(
                        Icons.logout,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: Constants.fontsUsed,
                    ),
                  ),
                  IconButton(
                      color: Constants.balckColor,
                      onPressed: () {
                        // ref.read(authControllerProvider.notifier).logoutUser();
                      },
                      icon: const Icon(
                        Icons.settings,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
