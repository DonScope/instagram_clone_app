import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  // هنا بنعمل ستيرم عشان يبقي ريل تايم وكلام جامد 
  Stream<QuerySnapshot> getMessages(String chatId){
    return _fireStore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: false).snapshots();
    
  }

  Future<void> sendMessage(String chatId, Map<String, dynamic> message, String fcmToken) async {

    await _fireStore.collection("chats").doc(chatId).collection('messages').add(message);
  }
}