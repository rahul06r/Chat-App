import 'dart:math';

import 'package:chat_app/Core/Providers/firebase_provider.dart';
import 'package:chat_app/Core/TypeDef/failure.dart';
import 'package:chat_app/Core/TypeDef/typedef.dart';
import 'package:chat_app/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../Core/Constant/firebase_constants.dart';

final userRepoProvider = Provider((ref) {
  return UserRepo(
      firebaseAuth: ref.read(authProvider),
      firebaseFirestore: ref.read(firestoreProvider));
});

class UserRepo {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  UserRepo({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  //edit the user here function

  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(
        _users.doc(user.uid).update(user.toMap()).then((value) {
          // print('Updated user name${user.name}');
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // get the particular user through uid

  Stream<UserModel> getUser(String id) {
    return _users.doc(id).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<List<UserModel>> getUsers(String id) {
    return _users.doc(id).snapshots().asyncMap((event) async {
      List<UserModel> userModels = [];

      var userData = event.data() as Map<String, dynamic>;
      // print(userData);
      var myUsers = userData['myUsers'] as List<dynamic>;
      // print(myUsers);

      for (var myUserId in myUsers) {
        var myUserDoc = await _users.doc(myUserId).get();
        // print(myUserDoc);
        if (myUserDoc.exists) {
          var myUserData = myUserDoc.data() as Map<String, dynamic>;
          var userModel = UserModel.fromMap(myUserData);
          userModels.add(userModel);
        }
      }

      return userModels;
    });
  }

  // get Requested Users

  Stream<List<UserModel>> getRequestedUsers(String id) {
    return _users.doc(id).snapshots().asyncMap((event) async {
      List<UserModel> userModels = [];

      var userData = event.data() as Map<String, dynamic>;
      // print(userData);
      var myUsers = userData['requestedUsers'] as List<dynamic>;
      // print(myUsers);

      for (var myUserId in myUsers) {
        var myUserDoc = await _users.doc(myUserId).get();
        // print(myUserDoc);
        if (myUserDoc.exists) {
          var myUserData = myUserDoc.data() as Map<String, dynamic>;
          var userModel = UserModel.fromMap(myUserData);
          userModels.add(userModel);
        }
      }

      return userModels;
    });
  }

  void requestUserToAdd(String requesterId, String requestedId) {
    _users.doc(requestedId).update({
      'requestedUsers': FieldValue.arrayUnion([requesterId]),
    });
  }

  //
  //
  //
  //

  void addUser(String requesterId, String requestedId) {
    _users.doc(requestedId).update({
      'requestedUsers': FieldValue.arrayRemove([requesterId]),
    });

    // add to myUsers of current user
    _users.doc(requestedId).update({
      'myUsers': FieldValue.arrayUnion([requesterId]),
    });
    // add to myUsers of other user
    _users.doc(requesterId).update({
      'myUsers': FieldValue.arrayUnion([requestedId]),
    });
  }

  Either<Failure, dynamic> deleteUserFromRequestedUser(
      String requesterId, String requestedId) {
    try {
      return right(
        _users.doc(requestedId).update({
          'requestedUsers': FieldValue.arrayRemove([requesterId]),
        }),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  Either<Failure, dynamic> deleteUserFromChatScreen(
      String requesterId, String requestedId) {
    try {
      _users.doc(requestedId).update({
        'myUsers': FieldValue.arrayRemove([requesterId]),
      });

      _users.doc(requesterId).update({
        'myUsers': FieldValue.arrayRemove([requestedId]),
      });

      return right(null); // Or you can return any other value if needed
    } catch (e) {
      return left(
        Failure('Cannot Remove'),
      );
    }
  }

  Stream<List<UserModel>> searchUser(String username) {
    return _users
        .where('name',
            isGreaterThanOrEqualTo:
                username.isEmpty ? 'No User Found' : username,
            isLessThan: username.isEmpty
                ? 'No User Found'
                : username.substring(0, username.length - 1) +
                    String.fromCharCode(
                        username.codeUnitAt(username.length - 1) + 1))
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var element in event.docs) {
        users.add(UserModel.fromMap(element.data() as Map<String, dynamic>));
      }
      return users;
    });
  }

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);
}
