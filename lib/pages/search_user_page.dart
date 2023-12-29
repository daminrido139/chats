import 'package:chats/components/profile_icon.dart';
import 'package:chats/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All users"),
        centerTitle: true,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: snapshot.data!.docs
                  .map((doc) => _buildUserListItem(doc))
                  .toList());
        });
  }

  Widget _buildUserListItem(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: profileIcon(data["name"]),
        title: Text(
          data['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(""),
        onTap: () {
          Future.delayed(const Duration(milliseconds: 300)).then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverName: data['name'],
                        receiverUserId: data['uid'],
                      ))));
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
