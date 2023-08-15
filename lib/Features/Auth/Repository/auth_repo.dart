import 'package:chat_app/Core/Constant/firebase_constants.dart';
import 'package:chat_app/Core/Providers/firebase_provider.dart';
import 'package:chat_app/Core/TypeDef/failure.dart';
import 'package:chat_app/Core/TypeDef/typedef.dart';
import 'package:chat_app/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepoProvider = Provider((ref) => AuthhRepo(
    firebaseAuth: ref.read(authProvider),
    firebaseFirestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSign)));

class AuthhRepo {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;
  AuthhRepo({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn;

  Stream<User?> get authStateChanged => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> siginInWithGoogle() async {
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final gooogleAuth = await googleSignInAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gooogleAuth?.accessToken,
        idToken: gooogleAuth?.idToken,
      );
      userCredential = await _firebaseAuth.signInWithCredential(credential);
      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          uid: userCredential.user!.uid,
          profilePic: userCredential.user!.photoURL ??
              userCredential.user!.displayName!.substring(1),
          myUsers: [],
          lastMessage: '',
          requestedUsers: [],
          // lastMsgTime: null,
          lastMessageType: '',
        );

        _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserdata(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserdata(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  // logout
  void logoutUser() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);
}
