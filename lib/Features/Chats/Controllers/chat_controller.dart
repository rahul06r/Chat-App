import 'dart:io';

import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:chat_app/Features/Chats/Repository/chatrepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Models/message_model.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatController, bool>((ref) {
  final chatRepo = ref.read(chatRepoProvider);

  return ChatController(chatRepo: chatRepo, ref: ref);
});

final getAllMessageProvider = StreamProvider.family((ref, String id) {
  final chatCon = ref.read(chatControllerProvider.notifier);

  return chatCon.getAllMessage(id);
});

class ChatController extends StateNotifier<bool> {
  final ChatRepo _chatRepo;
  final Ref _ref;
  ChatController({
    required ChatRepo chatRepo,
    required Ref ref,
  })  : _chatRepo = chatRepo,
        _ref = ref,
        super(false);

  //
  Stream<List<Messages>> getAllMessage(String id) {
    final user = _ref.read(userProvider)!;
    return _chatRepo.getAllMessageStream(user.uid, id);
  }

  Future<void> sendMessage(String toID, String msgs, String type) {
    return _chatRepo.sendMessage(toID, msgs, type);
  }

  Future<void> addChatImage(String toID, String fromId, String type,
      BuildContext context, File? chatImage) {
    return _chatRepo.addChatImage(fromId, toID, chatImage, context, type);
  }
  //
  // Future<void> updateReadTime(String senderId, String recId) {
  //   return _chatRepo.updateReadTime(senderId, recId);
  // }

  //

  Future<void> updateMessage(
    String msgId,
    String msg,
    String senderId,
    String recId,
  ) {
    return _chatRepo.updateMessage(msgId, msg, senderId, recId);
  }

  Future<void> deleteMessage(
    String msgID,
    String senderId,
    String recId,
  ) {
    return _chatRepo.deleteMessage(msgID, senderId, recId);
  }

  Future<void> deleteConversation(
      String senderId, String recId, BuildContext context) {
    return _chatRepo.deleteConversation(senderId, recId).then((value) {
      Navigator.pop(context);
    });
  }
}
