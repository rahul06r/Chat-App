import 'dart:io';

import 'package:chat_app/Core/Providers/firebase_provider.dart';
import 'package:chat_app/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../Core/Common/showSnackBar.dart';
import '../../../Core/Constant/firebase_constants.dart';
import '../../../Core/Providers/storage_provider.dart';

final chatRepoProvider = Provider((ref) {
  return ChatRepo(
    firebaseAuth: ref.read(authProvider),
    firebaseFirestore: ref.read(firestoreProvider),
    storageRepository: ref.watch(firebaseStorageProvider),
  );
});

class ChatRepo {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final StorageRepository _storageRepository;
  ChatRepo({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required StorageRepository storageRepository,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _storageRepository = storageRepository;

//C6bco1QQFrNDhMjHbn1CGnWsya62_npJxCocVYhM0KK80gaHJn7RhkUV2
// C6bco1QQFrNDhMjHbn1CGnWsya62_deSIogDSHmacsqoxd0TUXMWf5Om1

// 8yRiJeIvq7bNPdzL6MRqaAtvcKo1
// CrJXkFGoQQZZsTrrzEWAQ2JXzV52

// List<String> userIds = ['8yRiJeIvq7bNPdzL6MRqaAtvcKo1', 'CrJXkFGoQQZZsTrrzEWAQ2JXzV52'];
// userIds.sort((a, b) => a.compareTo(b)); // Sort the list in ascending order

// String chatId = userIds.join();
// print(chatId); // Output:
// "8yRiJeIvq7bNPdzL6MRqaAtvcKo1CrJXkFGoQQZZsTrrzEWAQ2JXzV52"
// 8yRiJeIvq7bNPdzL6MRqaAtvcKo1CrJXkFGoQQZZsTrrzEWAQ2JXzV52

// 8yRiJeIvq7bNPdzL6MRqaAtvcKo1_CrJXkFGoQQZZsTrrzEWAQ2JXzV52
// CrJXkFGoQQZZsTrrzEWAQ2JXzV52_8yRiJeIvq7bNPdzL6MRqaAtvcKo1

// 8yRiJeIvq7bNPdzL6MRqaAtvcKo1CrJXkFGoQQZZsTrrzEWAQ2JXzV52

  // String generateChatId(String userId1, String userId2) {
  //   List<String> userIds = [userId1, userId2];
  //   // userIds.sort();
  //   userIds.sort((userId1, userId2) => userId1.compareTo(userId2));

  //   String chatId = userIds.join();
  //   print(chatId);

  //   return chatId;
  // }
  String generateChatId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort((userId1, userId2) => userId1.compareTo(userId2));

    String chatId = userIds.join();
    print(chatId);

    return chatId;
  }

  // 4hhoeJasGLP4uRomU4pn9IQq9qP28RGWTJ1GxRbM7tWYPMSRhoqoTgI2
  // 4hhoeJasGLP4uRomU4pn9IQq9qP28RGWTJ1GxRbM7tWYPMSRhoqoTgI2

  // 4hhoeJasGLP4uRomU4pn9IQq9qP28RGWTJ1GxRbM7tWYPMSRhoqoTgI2

  // 4hhoeJasGLP4uRomU4pn9IQq9qP2

  // 8RGWTJ1GxRbM7tWYPMSRhoqoTgI2
  // result: 4hhoeJasGLP4uRomU4pn9IQq9qP28RGWTJ1GxRbM7tWYPMSRhoqoTgI2
  // result 2: 48RGWTJ1GxRbM7tWYPMSRhoqoTgI24hhoeJasGLP4uRomU4pn9IQq9qP2

  Stream<List<Messages>> getAllMessageStream(String senId, String recId) {
    // return _users
    //     .doc(senId)
    //     .collection('myChatsUsers')
    //     .doc(recId)
    //     .collection('particular')
    //     .doc(generateChatId(senId, recId))
    //     .collection('messages')
    //     .orderBy('senderTime', descending: false)
    //     .snapshots()
    //     .map((event) =>
    //         event.docs.map((e) => Messages.fromMap(e.data())).toList());

    return _chats
        .doc(generateChatId(senId, recId))
        .collection('messages')
        .orderBy('senderTime', descending: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) => Messages.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  //

  //
  Future<void> sendMessage(String recId, String msgs, String type) async {
    var uuid = const Uuid().v1();
    final user = _firebaseAuth.currentUser!.uid;
    final time = DateTime.now().millisecondsSinceEpoch;
    final ref = _chats.doc(generateChatId(user, recId)).collection('messages');
    final Messages messages = Messages(
      msgId: uuid,
      toId: recId,
      senderId: _firebaseAuth.currentUser!.uid,
      msg: msgs,
      isSender: true,
      senderTime: DateTime.now(),
      readTime: null,
      lastMessage: msgs,
      type: type,
    );
    // print(recId);
    await ref.doc(uuid).set(messages.toMap()).then((value) {
      // send msg
      _users.doc(user).update({
        'lastMessage': msgs,
        'lastMessageTime': time,
        'lastMessageType': type
      }).then((value) {
        print(type);
      });
      _users.doc(recId).update({
        'lastMessage': msgs,
        'lastMessageTime': time,
        'lastMessageType': type
      });
    });
  }

  //
  Future<void> addChatImage(String senderID, String recID, File? chatImage,
      BuildContext context, String type) async {
    final imagaResult = await _storageRepository.storeFile(
        path:
            'users/${generateChatId(senderID, recID)}/${DateTime.now().millisecondsSinceEpoch}',
        id: senderID,
        file: chatImage);

    imagaResult.fold((l) => showSnackBars(context, l.message), (r) async {
      sendMessage(recID, r, type);
    });
  }
  // FutureVoid addChatImage(
  //     Messages messages, String senderId, String recId) async {
  //   try {
  //     return right(
  //        final  imageResult=await _storageRepository.storeFile(path: 'users/${generateChatId(senderId, recId)}/${DateTime.now().millisecondsSinceEpoch}', id: senderId, file: chatImage);

  //         );
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  // Future<void> updateReadTime(String senderId, String recId) {
  //   return _firebaseFirestore
  //       .collection('chats')
  //       .doc(generateChatId(senderId, recId))
  //       .collection('messages')
  //       .doc(senderId)
  //       .update({
  //     'readTime': DateTime.now(),
  //   }).then((value) {
  //     print("completed");
  //   });
  // }

  Future<void> updateMessage(
      String msgId, String msg, String senderId, String recId) {
    return _chats
        .doc(generateChatId(senderId, recId))
        .collection('messages')
        .doc(msgId)
        .update({
      'msg': msg,
    }).then((value) {
      _users.doc(senderId).update({
        'lastMessage': msg,
      });
      _users.doc(recId).update({
        'lastMessage': msg,
      });
      if (kDebugMode) {
        print("${msg}completed update");
      }
    });
  }

  Future<void> deleteMessage(String msgID, String senderId, String recId) {
    return _chats
        .doc(generateChatId(senderId, recId))
        .collection('messages')
        .doc(msgID)
        .delete();
  }

  Future<void> deleteConversation(String senderId, String recId) {
    return _chats.doc(generateChatId(senderId, recId)).delete();
  }

// ucqrzOQoamXkmRBtxEllX9mEkNb2ywRzuBcE9qebRN3nhsPUL4aWhS42
// ucqrzOQoamXkmRBtxEllX9mEkNb2ywRzuBcE9qebRN3nhsPUL4aWhS42
  //
  CollectionReference get _chats =>
      _firebaseFirestore.collection(FirebaseConstants.chats);
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);
}
