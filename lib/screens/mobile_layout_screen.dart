import 'dart:io';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/features/chat/widgets/contact_list_group.dart';
import 'package:chatos_messenger/features/groups/screens/create_group_screen.dart';
import 'package:chatos_messenger/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chatos_messenger/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/features/chat/widgets/contacts_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/utils/utils.dart';
import '../features/status/screens/confirm_status_screen.dart';
import '../features/status/screens/status_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        centerTitle: false,
        title: const Text(
          'Chatos Messenger',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGroup(),
                    ),
                  );
                },
                icon: const Icon(Icons.group_add)),
          ),
        ],
        bottom: TabBar(
          controller: tabBarController,
          indicatorColor: Colors.amber,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(
              text: 'CHATS',
            ),
            Tab(
              text: 'GROUPS',
            ),
            // Tab(
            //   text: 'STATUS',
            // ),
          ],
        ),
      ),
      drawer: DrawerPage(),
      body: TabBarView(
        controller: tabBarController,
        children: const [
          ContactsList(),
          ContactsListGroup(),
          // StatusContactsScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tabBarController.index == 0) {
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
          } else if (tabBarController.index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateGroup(),
              ),
            );
          }
          //  else
          //   {
          //   File? pickedImage = await pickImageFromGallery(context);
          //   if (pickedImage != null) {
          //     Navigator.pushNamed(
          //       context,
          //       ConfirmStatusScreen.routeName,
          //       arguments: pickedImage,
          //     );
          //   }
          // }
        },
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.comment,
          color: Colors.white,
        ),
      ),
    );
  }
}
