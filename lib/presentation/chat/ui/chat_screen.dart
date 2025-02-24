import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/message_model.dart';
import 'package:instagram_clone_app/presentation/auth/widgets/custom_text_form_field.dart';
import 'package:instagram_clone_app/presentation/chat/cubit/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
   ChatScreen({super.key, required this.chatId, required this.currentUserId, required this.otherUserName, required this.fcmToken});
  final String chatId;
  final String currentUserId;
  final String otherUserName;
  final String fcmToken;
    final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
              var cubit = ChatCubit.get(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUserName),
      ),
      body: Column(
        children: [
          Expanded(child: BlocBuilder<ChatCubit,ChatState>(builder: (context, state) {
            if (state is ChatLoaded) {
              final messages = state.messages;
              return ListView.builder(
                itemCount: messages.length,

                itemBuilder: (context, index) {
                  final message = messages[index];
              final isMe = message.senderId == currentUserId;
              return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, 
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue[200] : Colors.grey,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(message.text),
              ),
              );
              
                } 
              );
            } else if (state is ChatError){
               return Center(child: Text("Error: ${state.error}"));
            } else { 
              return Center(child: CircularProgressIndicator());
            }
          },)),

          Padding(padding: EdgeInsets.all(8), child: CustomTextField(controller: _messageController, labelText: "Enter your message", ic: IconButton(onPressed: () {
            final text = _messageController.text.trim();
            if (text.isNotEmpty) {
              final message = MessageModel(text: text, senderId: currentUserId, id: "", timestamp: DateTime.now());
              cubit.sendMessage(chatId, message, fcmToken, text);
              _messageController.clear();
            }
          }, icon: Icon(Icons.send)),),)
        ],
      )
    );
  }
}