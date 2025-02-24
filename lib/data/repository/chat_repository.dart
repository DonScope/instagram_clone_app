import 'package:instagram_clone_app/core/helpers/generate_chat_id.dart';
import 'package:instagram_clone_app/core/web_services/chat_service.dart';
import 'package:instagram_clone_app/data/models/message_model.dart';

class ChatRepository {
  final ChatService _chatService;
  ChatRepository(this._chatService);


  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _chatService.getMessages(chatId).map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(
                doc.data() as Map<String, dynamic>,
                id: doc.id,
              ))
          .toList();
    });
  }


  Future<void> sendMessage(String chatId, MessageModel message, String fcmToken) async{ 
    return _chatService.sendMessage(chatId, message.toJson(), fcmToken);
  }

 String getChatId(String userId1, String userId2) {
    return generateChatId(userId1, userId2);
  }
}