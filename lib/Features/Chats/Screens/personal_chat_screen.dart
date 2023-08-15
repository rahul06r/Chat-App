import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Core/Common/error_text.dart';
import 'package:chat_app/Core/Common/loader.dart';
import 'package:chat_app/Core/Common/showSnackBar.dart';
import 'package:chat_app/Core/Constant/other_constant.dart';
import 'package:chat_app/Features/Auth/Controller/auth_controller.dart';
import 'package:chat_app/Features/Chats/Controllers/chat_controller.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalChatScreen extends ConsumerStatefulWidget {
  final String name;
  final String id;
  const PersonalChatScreen({super.key, required this.name, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalChatScreenState();
}

class _PersonalChatScreenState extends ConsumerState<PersonalChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _updateMsgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  var _prevMessageList;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLastMessage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _updateMsgController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToLastMessage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  File? chatImage;
  Future<void> selcteChatImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        chatImage = File(res.files.first.path!);
      });
    } else {
      // showSnackBars(context, 'Image Picking failed ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final width = MediaQuery.of(context).size.width;
    final heigth = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            // we can listtile to make last seen
            title: Text(widget.name),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('Delete User Conversation'),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                print(user.uid);
                                print(widget.id);
                                ref
                                    .watch(chatControllerProvider.notifier)
                                    .deleteConversation(
                                      user.uid,
                                      widget.id,
                                      context,
                                    );
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ref.watch(getAllMessageProvider(widget.id)).when(
                    data: (data) {
                      if (_prevMessageList != data) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToLastMessage();
                        });
                      }
                      _prevMessageList = data;

                      return ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final msg = data[index];
                          Widget image() {
                            return Container(
                              constraints: BoxConstraints(
                                maxWidth: width * .7,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: msg.msg,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            );
                          }

                          // if (msg.toId != widget.id && msg.readTime == null) {
                          //   ref
                          //       .watch(chatControllerProvider.notifier)
                          //       .updateReadTime(msg.senderId, msg.toId);
                          // }
                          return GestureDetector(
                            onLongPress: () {
                              msg.senderId == widget.id
                                  ? null
                                  : msg.type == 'msg'
                                      ? showModalBottomSheet(
                                          enableDrag: false,
                                          isDismissible: true,
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          builder: (_) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    var time = DateTime.now();

                                                    var res;
                                                    var msgt = msg.senderTime;

                                                    if (((time
                                                            .difference(msgt)
                                                            .inMinutes <
                                                        15))) {
                                                      Navigator.pop(context);
                                                      ref
                                                          .watch(
                                                              chatControllerProvider
                                                                  .notifier)
                                                          .deleteMessage(
                                                              msg.msgId,
                                                              msg.senderId,
                                                              msg.toId)
                                                          .then((value) {
                                                        flutterToast(
                                                          context,
                                                          'Deleted',
                                                        );
                                                      });
                                                      if (kDebugMode) {
                                                        print('true');
                                                      }
                                                    } else {
                                                      Navigator.pop(context);
                                                      flutterToast(
                                                        context,
                                                        'Time Exceeded 15mins',
                                                      );

                                                      if (kDebugMode) {
                                                        print('false');
                                                        print(time);
                                                      }
                                                    }
                                                  },
                                                  title: const Text(
                                                      'Delete Message'),
                                                  leading: const Icon(
                                                    Icons.delete,
                                                  ),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    var time = DateTime.now();

                                                    var msgt = msg.senderTime;
                                                    Navigator.pop(context);
                                                    if (((time
                                                            .difference(msgt)
                                                            .inMinutes <
                                                        15))) {
                                                      //
                                                      _updateMsgController
                                                          .text = msg.msg;

                                                      //
                                                      showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10,
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 15),
                                                            title: const Text(
                                                              "Edit Message",
                                                            ),
                                                            content: TextFormField(
                                                                controller:
                                                                    _updateMsgController,
                                                                decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)))),
                                                            actions: [
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                  style:
                                                                      TextStyle(),
                                                                ),
                                                              ),
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  ref
                                                                      .watch(chatControllerProvider
                                                                          .notifier)
                                                                      .updateMessage(
                                                                        msg.msgId,
                                                                        _updateMsgController
                                                                            .text,
                                                                        msg.senderId,
                                                                        msg.toId,
                                                                      )
                                                                      .then(
                                                                          (value) {
                                                                    _focusNode
                                                                        .unfocus();
                                                                    flutterToast(
                                                                        context,
                                                                        'Edited Successfully');
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Update",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Constants
                                                                        .mainColor,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                      );

                                                      //
                                                      if (kDebugMode) {
                                                        print('true');
                                                      }
                                                    } else {
                                                      if (kDebugMode) {
                                                        print('false');
                                                        print(time);
                                                      }
                                                      //

                                                      //
                                                      flutterToast(context,
                                                          'Time Exceeded 10 mins');

                                                      //
                                                    }

                                                    print(msg.msgId);
                                                  },
                                                  title: const Text(
                                                      'Edit Message'),
                                                  leading: const Icon(
                                                    Icons.edit,
                                                  ),
                                                )
                                              ],
                                            );
                                          })
                                      : null;
                            },
                            child: msg.type == 'msg'
                                ? Container(
                                    margin: EdgeInsets.only(
                                      bottom: 10,
                                      right: msg.toId == widget.id
                                          ? 0
                                          : width * .15,
                                      left: msg.toId == widget.id
                                          ? width * .15
                                          : 0,
                                    ),
                                    alignment: msg.toId == widget.id
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child: Container(
                                      // width: width * .8,

                                      decoration: BoxDecoration(
                                        color: msg.toId == widget.id
                                            ? Constants.darkgreenColor
                                            : Constants.mainColor,
                                        borderRadius: BorderRadius.only(
                                          topRight: const Radius.circular(20),
                                          topLeft: msg.toId == widget.id
                                              ? const Radius.circular(20)
                                              : Radius.zero,
                                          bottomLeft: const Radius.circular(15),
                                          bottomRight: msg.toId == widget.id
                                              ? Radius.zero
                                              : const Radius.circular(20),
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            msg.toId == widget.id
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: msg.toId == widget.id
                                                    ? 10
                                                    : 15,
                                                right: msg.toId == widget.id
                                                    ? 15
                                                    : 10,
                                                top: 10),
                                            child: Text(
                                              msg.msg,
                                              style: const TextStyle(
                                                color: Constants.whiteColor,
                                                overflow: TextOverflow.visible,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: msg.toId == widget.id
                                                  ? 12
                                                  : 5,
                                              right: msg.toId == widget.id
                                                  ? 10
                                                  : 0,
                                            ),
                                            child: Text(
                                              DateFormat('hh:mm a')
                                                  .format(msg.senderTime),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : BubbleNormalImage(
                                    isSender:
                                        msg.toId == widget.id ? true : false,
                                    id: msg.msgId,
                                    image: image(),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              Navigator.pop(context, false);
                                              return false;
                                            },
                                            child: SafeArea(
                                              child: Container(
                                                color: Colors.black,
                                                height: heigth,
                                                width: width,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons.arrow_back),
                                                        ),
                                                        const SizedBox(
                                                            width: 15),
                                                        Text(
                                                          msg.senderId ==
                                                                  widget.id
                                                              ? widget.name
                                                              : user.name,
                                                          style:
                                                              const TextStyle(
                                                            color: Constants
                                                                .whiteColor,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Expanded(
                                                      child: Center(
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            minHeight:
                                                                heigth * 0.8,
                                                            maxWidth: width,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: msg.msg,
                                                            progressIndicatorBuilder: (context,
                                                                    url,
                                                                    downloadProgress) =>
                                                                CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    color: msg.toId == widget.id
                                        ? Constants.darkgreenColor
                                        : Constants.mainColor,
                                    tail: true,
                                    delivered: true,
                                  ),
                          );
                        },
                      );
                    },
                    error: (e, stacktrace) =>
                        ErrorText(errorMessage: e.toString()),
                    loading: () => const Loader()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  controller: _msgController,
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            //
                            if (kDebugMode) {
                              print("Camera Pressed");
                            }
                            selcteChatImage().then((value) {
                              ref
                                  .watch(chatControllerProvider.notifier)
                                  .addChatImage(widget.id, user.uid, 'image',
                                      context, chatImage);
                            });
                          },
                          icon: const Icon(Icons.camera_alt_outlined)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (_msgController.text.isNotEmpty) {
                              ref
                                  .read(chatControllerProvider.notifier)
                                  .sendMessage(
                                      widget.id, _msgController.text, 'msg')
                                  .then((value) {
                                _scrollToLastMessage();
                              });
                              _msgController.text = '';
                            } else {
                              showSnackBars(context, 'Enter the Message');
                              _msgController.text = '';
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// if contains firebase the show a image icon in it
