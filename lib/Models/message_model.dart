// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:chat_app/Core/TypeDef/enums.dart';

class Messages {
  final String toId;
  final String senderId;
  final String msg;
  final bool isSender;
  final DateTime senderTime;
  final DateTime? readTime;
  final String msgId;
  final String? lastMessage;
  final String type;

  Messages({
    required this.toId,
    required this.senderId,
    required this.msg,
    required this.isSender,
    required this.senderTime,
    this.readTime,
    required this.msgId,
    this.lastMessage,
    required this.type,
  });

  Messages copyWith({
    String? toId,
    String? senderId,
    String? msg,
    bool? isSender,
    DateTime? senderTime,
    DateTime? readTime,
    String? msgId,
    String? lastMessage,
    String? type,
  }) {
    return Messages(
      toId: toId ?? this.toId,
      senderId: senderId ?? this.senderId,
      msg: msg ?? this.msg,
      isSender: isSender ?? this.isSender,
      senderTime: senderTime ?? this.senderTime,
      readTime: readTime ?? this.readTime,
      msgId: msgId ?? this.msgId,
      lastMessage: lastMessage ?? this.lastMessage,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toId': toId,
      'senderId': senderId,
      'msg': msg,
      'isSender': isSender,
      'senderTime': senderTime.millisecondsSinceEpoch,
      'readTime': readTime?.millisecondsSinceEpoch,
      'msgId': msgId,
      'lastMessage': lastMessage,
      'type': type,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      toId: map['toId'] as String,
      senderId: map['senderId'] as String,
      msg: map['msg'] as String,
      isSender: map['isSender'] as bool,
      senderTime: DateTime.fromMillisecondsSinceEpoch(map['senderTime'] as int),
      readTime: map['readTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['readTime'] as int)
          : null,
      msgId: map['msgId'] as String,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) =>
      Messages.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Messages(toId: $toId, senderId: $senderId, msg: $msg, isSender: $isSender, senderTime: $senderTime, readTime: $readTime, msgId: $msgId, lastMessage: $lastMessage, type: $type)';
  }

  @override
  bool operator ==(covariant Messages other) {
    if (identical(this, other)) return true;

    return other.toId == toId &&
        other.senderId == senderId &&
        other.msg == msg &&
        other.isSender == isSender &&
        other.senderTime == senderTime &&
        other.readTime == readTime &&
        other.msgId == msgId &&
        other.lastMessage == lastMessage &&
        other.type == type;
  }

  @override
  int get hashCode {
    return toId.hashCode ^
        senderId.hashCode ^
        msg.hashCode ^
        isSender.hashCode ^
        senderTime.hashCode ^
        readTime.hashCode ^
        msgId.hashCode ^
        lastMessage.hashCode ^
        type.hashCode;
  }
}
