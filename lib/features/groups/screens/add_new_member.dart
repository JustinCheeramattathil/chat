import 'dart:ui';
import 'package:chatos_messenger/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/features/groups/controller/group_controller.dart';
import 'package:chatos_messenger/features/groups/widgets/select_contact_group.dart';
import 'package:chatos_messenger/models/group.dart';

import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../select_contacts/controller/select_contacts_controller.dart';

class AddNewMember extends ConsumerStatefulWidget {
  static const String routeName = '/add-new';

  final String groupId;

  AddNewMember(this.groupId);

  @override
  ConsumerState<AddNewMember> createState() => _AddNewMemberState();
}

class _AddNewMemberState extends ConsumerState<AddNewMember> {
  final TextEditingController groupnameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    groupnameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Add new Member'),
        centerTitle: true,
      ),
      body: FutureBuilder<GroupModel>(
        future: ref.read(chatControllerProvider).fetchGroupData(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoaderWidget(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching data"),
            );
          }
          var groupdata = snapshot.data;
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(groupdata!.groupPic)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                          controller: groupnameController,
                          decoration: InputDecoration(
                              hintText: groupdata.name,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.amber),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.amber),
                                  borderRadius: BorderRadius.circular(10)))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Select Contacts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 1,
                ),
                const SelectContactsGroup(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        label: const Text("Create"),
        onPressed: () {
          List<String> selectedContsctsUid = [];
          ref.watch(getContactsProvider).when(
              data: (contactList) {
                for (int i = 0; i <= contactList.length; i++) {
                  if (selectedContactsIndex.contains(i)) {
                    selectedContsctsUid.add(
                      contactList[i].phones[0].number.replaceAll(
                            ' ',
                            '',
                          ),
                    );
                  }
                }
                return;
              },
              error: (err, trace) => ErrorScreen(error: err.toString()),
              loading: () => const LoaderWidget());
          ref
              .read(groupControllerProvider)
              .addnewMember(context, widget.groupId, selectedContsctsUid);
        },
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
