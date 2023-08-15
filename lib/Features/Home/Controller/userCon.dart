import 'dart:io';

import 'package:chat_app/Core/Common/showSnackBar.dart';
import 'package:chat_app/Core/Providers/firebase_provider.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:chat_app/Features/Home/Repo/userRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Core/Providers/storage_provider.dart';
import '../../../Models/user_model.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, bool>((ref) {
  final userRepo = ref.watch(userRepoProvider);

  return UserController(
      userRepo: userRepo,
      ref: ref,
      storageRepository: ref.watch(firebaseStorageProvider));
});

//

final numberOfUserProvider = StreamProvider((ref) {
  final userContro = ref.watch(userControllerProvider.notifier);
  return userContro.getUsers();
});
final mainUserProvider = StreamProvider.family((ref, String userID) {
  final userContro = ref.watch(userControllerProvider.notifier);

  return userContro.getUser(userID);
});

final searchUsersProvider = StreamProvider.family((ref, String userName) {
  final userContro = ref.watch(userControllerProvider.notifier);
  return userContro.searchUsers(userName);
});

final getRequestedUsersProvider = StreamProvider((ref) {
  final userContro = ref.watch(userControllerProvider.notifier);
  return userContro.getRequestedUsers();
});

class UserController extends StateNotifier<bool> {
  final UserRepo _userRepo;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserController({
    required UserRepo userRepo,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userRepo = userRepo,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  // edit user profile
  void editUserProfile({
    required String name,
    required BuildContext context,
    required File? profileImage,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileImage != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profileImage', id: user.uid, file: profileImage);

      res.fold(
        (l) => showSnackBars(context, l.message),
        (r) {
          user = user.copyWith(profilePic: r);
          if (kDebugMode) {
            print('Profile pic from controller ${user.profilePic}');
          }
          // flutterToast(context, 'Profile photo updated');
          Routemaster.of(context).pop();
        },
      );
    }
    user = user.copyWith(name: name);
    final res = await _userRepo.editUserProfile(user);

    state = false;

    res.fold(
      (l) => showSnackBars(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        // flutterToast(context, 'Profile name Updated');
        if (kDebugMode) {
          print("Controller ${user.name}");
        }
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<UserModel>> getUsers() {
    final user = _ref.read(userProvider)!;
    return _userRepo.getUsers(user.uid);
  }

  Stream<UserModel> getUser(String userId) {
    final user = _ref.read(userProvider)!;
    return _userRepo.getUser(user.uid);
  }

  Stream<List<UserModel>> searchUsers(String userName) {
    return _userRepo.searchUser(userName);
  }

  Stream<List<UserModel>> getRequestedUsers() {
    final user = _ref.read(userProvider)!;
    return _userRepo.getRequestedUsers(user.uid);
  }

  void requestUserToAdd(String requestedId, String requesterId) {
    return _userRepo.requestUserToAdd(requestedId, requesterId);
  }

  void addUser(String requestedId, String requesterId) {
    return _userRepo.addUser(requesterId, requestedId);
  }

  void deleteUserFromRequestedUser(
      String requestedId, String requesterId, BuildContext context) {
    _userRepo.deleteUserFromRequestedUser(requesterId, requestedId);
    // flutterToast(context, 'Deleted Successfully');
    showSnackBars(context, 'Deleted Successfully');
  }

  void deleteUserFromChatScreen(
      String requestedId, String requesterId, BuildContext context) {
    _userRepo.deleteUserFromChatScreen(requesterId, requestedId);
    // flutterToast(context, )
  }

  // ucqrzOQoamXkmRBtxEllX9mEkNb2
  // xhVIx6JonFU0Vf2QixaFVbWxbCR2
}
