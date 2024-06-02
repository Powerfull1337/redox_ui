import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redox_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:redox_ui/common/utils/utils.dart';
import 'package:redox_ui/models/status_model.dart';
import 'package:redox_ui/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

 Future<List<Status>> getStatus(BuildContext context) async {
  List<Status> statusData = [];
  try {
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) {
      showSnackBar(context: context, content: 'Contacts permission not granted');
      return [];
    }

    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

    // Debugging contacts loaded
    if (contacts.isEmpty) {
      showSnackBar(context: context, content: 'No contacts found');
      return [];
    }

    for (int i = 0; i < contacts.length; i++) {
      var contactPhone = contacts[i].phones.isNotEmpty ? contacts[i].phones[0].number.replaceAll(' ', '') : '';
      if (contactPhone.isEmpty) continue;


      var statusesSnapshot = await firestore
          .collection('status')
          .where('phoneNumber', isEqualTo: contactPhone)
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      // Debugging fetched statuses


      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
          statusData.add(tempStatus);
        }
      }
    }

    // Debugging final status list
    print('Final statuses count: ${statusData.length}');

  } catch (e) {
    if (kDebugMode) print(e);
    showSnackBar(context: context, content: e.toString());
  }
  return statusData;
}
}