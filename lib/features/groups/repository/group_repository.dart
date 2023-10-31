import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:chatos_messenger/common/repositories/common_firebase_storage_repository.dart';
import 'package:chatos_messenger/common/utils/utils.dart';
import 'package:chatos_messenger/models/group.dart';

import '../../../models/user_model.dart';
import '../../../screens/widget/success_snackbar.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var usercollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo:
                  selectedContact[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();
        if (usercollection.docs.isNotEmpty && usercollection.docs[0].exists) {
          uids.add(usercollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupId', profilePic);
      GroupModel group = GroupModel(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [
          auth.currentUser!.uid,
          ...uids,
        ],
        timesent: DateTime.now(),
      );
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      // showSnackBar(context:context,content: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: SuccessSnackBar(errorText: 'group created successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  Stream<GroupModel> groupData(String groupId) {
    return firestore.collection('groups').doc(groupId).snapshots().map(
          (event) => GroupModel.fromMap(
            event.data()!,
          ),
        );
  }

  Future<void> addMemberToGroup(
      BuildContext context, String groupId, List<String> newMemberUid) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        for (int i = 0; i < newMemberUid.length; i++) {
          String selectedPhoneNum = newMemberUid[i];
          if (selectedPhoneNum == userData.phoneNumber) {
            isFound = true;
            try {
              DocumentSnapshot groupDoc =
                  await firestore.collection('groups').doc(groupId).get();

              if (groupDoc.exists) {
                List<dynamic> currentMembers = groupDoc['membersUid'];
                bool memberExists = false;

                for (int i = 0; i < newMemberUid.length; i++) {
                  if (!currentMembers.contains(userData.uid)) {
                    currentMembers.add(userData.uid);
                    await firestore.collection('groups').doc(groupId).update({
                      'membersUid': currentMembers,
                    });
                    log('newmember added${newMemberUid[i]}');
                  } else {
                    memberExists = true;
                  }
                }

                if (memberExists) {
                  throw 'One or more members already exist in the group.';
                }
              } else {
                throw 'Group not found.';
              }
            } catch (e) {
              showSnackBar(context: context, content: e.toString());
            }
          } else {
            showSnackBar(
              context: context,
              content: 'This number does not exist on this app.',
            );
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
