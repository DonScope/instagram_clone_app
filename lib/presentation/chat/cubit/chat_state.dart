part of 'chat_cubit.dart';
//  ده  بيقارن مبين اوبجيكتس بيساعد علي حالة الاستيت وحاجات جامدة equetable المعلم 
abstract class ChatState extends Equatable {
const ChatState();
@override
// هنا بقي الخصائص الي هنتسخدمها ف المقارنة 
List<Object?> get props => [];


}



class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState{
  final List<MessageModel> messages;

  ChatLoaded(this.messages);
  // بنضيف الليستة دي في الخصائص عشان المقارنة تكون مظبوطة
    @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(this.error);

  // بنضيف رسالة الخطأ في الخصائص عشان المقارنة
  @override
  List<Object?> get props => [error];
}