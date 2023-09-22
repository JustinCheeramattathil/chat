import 'dart:io';
import 'package:chatos_messenger/common/utils/utils.dart';
import 'package:chatos_messenger/common/widgets/custom_button.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/screens/widget/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.2),
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
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Enter your name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(10)))),
                )
              ],
            ),
            CustomButton(
                text: 'save',
                onPressed: (){
                  storeUserData();
                  
                  const SuccessSnackBar(
                      errorText: 'Account Created Successfully');
                }),
          ],
        )),
      ),
    ));
  }
}
