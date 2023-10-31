import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/common/widgets/loader.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/features/call/controller/call_controller.dart';
import 'package:chatos_messenger/features/call/screens/call_pick_up_screen.dart';
import 'package:chatos_messenger/features/chat/widgets/bottom_chat_field.dart';
import 'package:chatos_messenger/features/chat/widgets/chat_list.dart';
import 'package:chatos_messenger/features/groups/controller/group_controller.dart';
import 'package:chatos_messenger/features/groups/screens/add_new_member.dart';
import 'package:chatos_messenger/models/group.dart';
import 'package:chatos_messenger/models/user_model.dart';

final counterProvider = StateProvider<bool>((ref) => false);

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String? profilePic;

  MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic!,
          isGroupChat,
        );
  }

  void makeAudioCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeAudioCall(
          context,
          name,
          uid,
          profilePic!,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? StreamBuilder<GroupModel>(
                  stream: ref.read(groupControllerProvider).groupDatabyId(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoaderWidget();
                    }
                    var userdata = snapshot.data;
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, 0),
                                  content: CircleAvatar(
                                    radius: 130,
                                    backgroundImage:
                                        NetworkImage(userdata.groupPic),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userdata!.groupPic),
                            backgroundColor: Colors.grey,
                            radius: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) => AddNewMember(uid),
                        //     ));
                        //   },
                        //   icon: const Icon(Icons.person_add),
                        // ),
                      ],
                    );
                  },
                )
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoaderWidget();
                    }
                    var userdata = snapshot.data;
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 0, 0, 0),
                                  content: CircleAvatar(
                                    radius: 130,
                                    backgroundImage:
                                        NetworkImage(userdata.profilePic),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userdata!.profilePic),
                            backgroundColor: Colors.grey,
                            radius: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(snapshot.data!.isOnline ? 'online' : 'offline',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                makeCall(ref, context);
              },
              icon: const Icon(IconlyLight.video),
            ),
            IconButton(
              onPressed: () {
                makeAudioCall(ref, context);
              },
              icon: const Icon(IconlyLight.call),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
