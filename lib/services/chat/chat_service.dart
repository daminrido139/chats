import 'package:chats/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    final Message newMessage = Message(
      currentUserId,
      receiverId,
      message,
      timestamp,
    );
    final List<String> ids = [currentUserId, receiverId];
    ids.sort();
    final String chatRoomId = ids.join("_");

    // updating in the chat room
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    // setting update in the currentuid
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chat_info')
        .doc(receiverId)
        .set({
      "uid": receiverId,
      "timestamp": timestamp,
      "last_message": message,
      "seen": true,
    }, SetOptions(merge: true));

    // setting update in the recieveruid
    await _firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat_info')
        .doc(currentUserId)
        .set({
      "uid": currentUserId,
      "timestamp": timestamp,
      "last_message": message,
      "seen": false,
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    final List<String> ids = [userId, otherUserId];
    ids.sort();
    final String chatRoomId = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  void seen(String receiverId) async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('chat_info')
        .doc(receiverId)
        .set({"seen": true}, SetOptions(merge: true));
  }
}
