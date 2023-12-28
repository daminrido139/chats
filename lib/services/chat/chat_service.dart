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

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
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
}
