import 'dart:io';

import 'package:chatting_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static late ChatUser me;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) {
          getSelfInfo();
        });
      }
    });
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    me.image = await ref.getDownloadURL();

    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final chatuser = ChatUser(
        name: user.displayName.toString(),
        id: user.uid,
        email: user.email.toString(),
        image: user.photoURL.toString(),
        about: 'im app user',
        createdAt: time.toString(),
        isOnline: false,
        lastActive: time.toString(),
        pushToken: ' ');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

//used for getting all users from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore
        .collection('messages')
        
        .snapshots();
  }
}
