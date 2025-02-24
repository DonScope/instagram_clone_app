import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/web_services/api_client.dart';
import 'package:instagram_clone_app/data/models/message_model.dart';
import 'package:instagram_clone_app/data/repository/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<MessageModel>>? _messageSubscription;

  ChatCubit(this._chatRepository) : super(ChatInitial());
    static ChatCubit get(context) => BlocProvider.of(context);
  // هنا بقي بنسمع الشات عشان يتجدد وقتي
  void listenToMessages(String chatId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository.streamMessages(chatId).listen(
      (message) {
        emit(ChatLoaded(message));
      },
      onError: (error) {
        emit(ChatError(error));
      },
    );
  }

  Future<void> sendMessage(String chatId, MessageModel message, String fcmToken, String fcmMessage) async {
    try {
      await _chatRepository.sendMessage(chatId, message, fcmToken).then((value) async{
        await DioHelper.postData(fcmToken, "Message", fcmMessage);
      },);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // نتأكد اننا بنلغي الاشتراك لما الكيوبت يتقفل
    _messageSubscription?.cancel();
    return super.close();
  }
}
