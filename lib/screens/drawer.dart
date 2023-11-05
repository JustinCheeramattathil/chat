import 'package:chatos_messenger/features/auth/screens/edit_user_info.dart';
import 'package:chatos_messenger/widgets/about.dart';
import 'package:chatos_messenger/screens/widget/custom_snackbar.dart';
import 'package:chatos_messenger/widgets/privacy_policy.dart';
import 'package:chatos_messenger/widgets/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatos_messenger/common/widgets/loader.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/features/groups/screens/create_group_screen.dart';
import 'package:chatos_messenger/features/splash/screens/landing_screen.dart';
import 'package:chatos_messenger/models/user_model.dart';
import 'package:share_plus/share_plus.dart';

class DrawerPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserModel?>(
      future: ref.read(authControllerProvider).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: LoaderWidget(),
          );
        }

        if (snapshot.hasError) {
          return const Drawer(
            child: Text("Error fetching data"),
          );
        }

        final userData = snapshot.data;
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditUserInformation(),
                        ));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData!.profilePic),
                        radius: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userData.name),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(userData.phoneNumber),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.group_add,
                ),
                title: const Text('Create Group'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGroup(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock,
                ),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Terms and Conditions'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditions(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share,
                ),
                title: const Text('Share'),
                onTap: () {
                  Share.share("https://www.amazon.com/gp/product/B0CM9CCB3G");
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                ),
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Signout!!!',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                            'This action will log out you from personal chats, group chat, etc.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              // ref
                              //     .read(authControllerProvider)
                              //     .deleteUser(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LandingScreen(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: CustomSnackBar(
                                      errorText: 'Logged out Successfully'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
