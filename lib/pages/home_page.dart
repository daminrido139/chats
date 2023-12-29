import 'package:chats/components/profile_icon.dart';
import 'package:chats/pages/chat_page.dart';
import 'package:chats/pages/search_user_page.dart';
import 'package:chats/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text("Chats"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              )),
          IconButton(
              onPressed: signOut,
              icon: const Icon(
                Icons.logout,
              )),
        ],
      ),
      body: _loadChatList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchUserPage(),
              )),
          child: const Icon(Icons.message)),
    );
  }

  Widget _loadChatList() {
    return StreamBuilder(
      stream: _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("chat_info")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
            children:
                snapshot.data!.docs.map((e) => _chatListItem(e)).toList());
      },
    );
  }

  Widget _chatListItem(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StreamBuilder(
      stream: _firestore.collection("users").doc(data["uid"]).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.hasData) {
          final userData = snapshot.data!.data()!;
          return ListTile(
            leading: profileIcon(userData['name']),
            title: Text(
              userData['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              data["last_message"] ?? "",
              style: TextStyle(
                  color: const Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: (data["seen"] ?? true) ? null : FontWeight.w900),
            ),
            trailing: (!data["seen"])
                ? Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    width: 20,
                    height: 20,
                  )
                : null,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300))
                  .then((value) => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatPage(
                            receiverName: userData['name'],
                            receiverUserId: data['uid'],
                          ))));
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
