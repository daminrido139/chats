import 'package:chats/components/chat_bubble.dart';
import 'package:chats/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserId;
  final String receiverEmail;
  const ChatPage({
    super.key,
    required this.receiverUserId,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isEmpty) return;
    await _chatService.sendMessage(
        widget.receiverUserId, _messageController.text);
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        toolbarHeight: 80,
        title: Text(
          widget.receiverEmail,
        ),
      ),
      body: Column(children: [
        Expanded(child: _buildMessageList()),
        _buildMessageInput(),
      ]),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            _auth.currentUser!.uid, widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            reverse: true,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageListItem(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final Color color;
    final Alignment alignment;
    if (_auth.currentUser!.uid == data['senderId']) {
      alignment = Alignment.centerRight;
      color = Theme.of(context).colorScheme.tertiary;
    } else {
      alignment = Alignment.centerLeft;
      color = Theme.of(context).colorScheme.secondary;
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        alignment: alignment,
        child: ChatBubble(text: data["message"], color: color));
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child:
              Padding(padding: const EdgeInsets.all(8.0), child: _textField()),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
          child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        )
      ],
    );
  }

  Widget _textField() {
    return TextField(
      controller: _messageController,
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          isCollapsed: true,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: "Message",
          hintStyle: TextStyle(
              color: Colors.grey.shade700, fontWeight: FontWeight.w200)),
    );
  }
}
