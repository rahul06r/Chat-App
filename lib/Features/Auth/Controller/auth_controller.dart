import 'package:chat_app/Features/Auth/Repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/Common/showSnackBar.dart';
import '../../../Models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(authhRepo: ref.read(authRepoProvider), ref: ref));

final getUserdataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.read(authControllerProvider.notifier);
  return authController.getUserdata(uid);
});

final authStateChangedProvider = StreamProvider((ref) {
  final authController = ref.read(authControllerProvider.notifier);
  return authController.authStateChanged;
});

class AuthController extends StateNotifier<bool> {
  final AuthhRepo _authhRepo;
  final Ref _ref;
  AuthController({required AuthhRepo authhRepo, required Ref ref})
      : _authhRepo = authhRepo,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanged => _authhRepo.authStateChanged;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authhRepo.siginInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBars(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  Stream<UserModel> getUserdata(String uid) {
    return _authhRepo.getUserdata(uid);
  }

  void logoutUser() async {
    _authhRepo.logoutUser();
  }
}
