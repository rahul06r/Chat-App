// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final List<dynamic> myUsers;
  final String? lastMessage;
  final String? lastMessageType;
  final List<dynamic> requestedUsers;
  final DateTime? lastMessageTime;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.myUsers,
    required this.lastMessage,
    required this.lastMessageType,
    required this.requestedUsers,
    this.lastMessageTime,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    List<dynamic>? myUsers,
    String? lastMessage,
    String? lastMessageType,
    List<dynamic>? requestedUsers,
    DateTime? lastMessageTime,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      myUsers: myUsers ?? this.myUsers,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      requestedUsers: requestedUsers ?? this.requestedUsers,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'myUsers': myUsers,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'requestedUsers': requestedUsers,
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      uid: map['uid'] as String,
      myUsers: List<dynamic>.from((map['myUsers'] as List<dynamic>)),
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageType: map['lastMessageType'] != null
          ? map['lastMessageType'] as String
          : null,
      requestedUsers:
          List<dynamic>.from((map['requestedUsers'] as List<dynamic>)),
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'] as int)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, uid: $uid, myUsers: $myUsers, lastMessage: $lastMessage, lastMessageType: $lastMessageType, requestedUsers: $requestedUsers, lastMessageTime: $lastMessageTime)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        listEquals(other.myUsers, myUsers) &&
        other.lastMessage == lastMessage &&
        other.lastMessageType == lastMessageType &&
        listEquals(other.requestedUsers, requestedUsers) &&
        other.lastMessageTime == lastMessageTime;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        uid.hashCode ^
        myUsers.hashCode ^
        lastMessage.hashCode ^
        lastMessageType.hashCode ^
        requestedUsers.hashCode ^
        lastMessageTime.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
