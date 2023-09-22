import 'dart:io';
import 'dart:ui';
import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/common/utils/utils.dart';
import 'package:chatos_messenger/features/groups/controller/group_controller.dart';
import 'package:chatos_messenger/features/groups/widgets/select_contact_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroup extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroup({super.key});

  @override
  ConsumerState<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends ConsumerState<CreateGroup> {
  final TextEditingController groupnameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() async {
    if (groupnameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupnameController.text.trim(),
            image!,
            ref.read(
              SelectedGroupsContacts,
            ),
          );
      ref.read(SelectedGroupsContacts.state).update((state) => []);
      Navigator.pop(context);
    }
  }

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
        title: const Text('Create Group'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'),
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(
                          image!,
                        ),
                      ),
                Positioned(
                    bottom: -11,
                    left: 100,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: IconButton(
                          color: Colors.amber,
                          onPressed: selectImage,
                          icon: const Icon(Icons.camera_alt)),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        controller: groupnameController,
                        decoration: InputDecoration(
                            hintText: 'Enter the Groupname',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                                borderRadius: BorderRadius.circular(5)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                                borderRadius: BorderRadius.circular(10)))),
                  ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Create"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: createGroup,
        backgroundColor: Colors.amber,
        icon: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
