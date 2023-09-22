import 'dart:io';

import 'package:chatos_messenger/common/utils/utils.dart';
import 'package:chatos_messenger/common/widgets/custom_button.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/models/user_model.dart';
import 'package:chatos_messenger/screens/widget/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loader.dart';

class EditUserInformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const EditUserInformation({super.key});

  @override
  ConsumerState<EditUserInformation> createState() =>
      _EditUserInformationState();
}

class _EditUserInformationState extends ConsumerState<EditUserInformation> {
  final TextEditingController namesController = TextEditingController();
  File? image;
  bool isLoading = true;
  UserModel? userData;

  @override
  void dispose() {
    super.dispose();
    namesController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void updateUserData() async {
    String name = namesController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      final loadedUserData =
          await ref.read(authControllerProvider).getUserData();
      if (loadedUserData != null) {
        namesController.text = loadedUserData.name;
        setState(() {
          userData = loadedUserData;
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Edit your Information'),
          centerTitle: true,
        ),
        body: isLoading
            ? const LoaderWidget()
            : SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.2),
                      Stack(
                        children: [
                          image == null
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      NetworkImage(userData!.profilePic),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: FileImage(
                                    image!,
                                  ),
                                ),
                          Positioned(
                              bottom: -12,
                              left: 100,
                              child: IconButton(
                                  color: Colors.amber,
                                  onPressed: selectImage,
                                  icon: const Icon(Icons.camera_alt)))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.85,
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                                controller: namesController,
                                decoration: InputDecoration(
                                    hintText: userData!.name,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.amber),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.amber),
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                          )
                        ],
                      ),
                      CustomButton(
                          text: 'Update',
                          onPressed: () async {
                            updateUserData();
                            const SuccessSnackBar(
                                errorText: 'Account updated successfully');
                          }),
                    ],
                  )),
                ),
              ));
  }
}
