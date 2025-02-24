import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/data/models/user_model.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._userRepository) : super(SearchInitial());
  final UserRepository _userRepository;
  static SearchCubit get(context) => BlocProvider.of(context);

  List<UserModel> allUsers = [];

  Future<void> fetchAllUsers() async {
    try {
      emit(SearchLoading());
      final users = await _userRepository.fetchAllUsers();
      allUsers = users;
      emit(SearchSuccess(users));
    } catch (e) {
      emit(SearchError());
    }
  }

  void search(String text) {
    if (text.isEmpty) {
      emit(SearchSuccess(allUsers));
    } else {
      final filteredUsers = allUsers
          .where((user) =>
              user.name!.toLowerCase().contains(text.toLowerCase()))
          .toList();
      emit(SearchSuccess(filteredUsers));
    }
  }

  Future<void> createChatIfNotExists({
  required String chatId,
  required List<String> participants,
}) async {
  final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
  final docSnapshot = await chatDoc.get();
  if (!docSnapshot.exists) {
    // لو الدكيومنت مش موجود، ننشئه ونحط فيه معلومات المشاركين
    await chatDoc.set({
      'participants': participants,
      'lastUpdated': FieldValue.serverTimestamp(),
      // ممكن تضيف حقول تانية زي lastMessage أو اسم المحادثة لو حابب
    });
  }
}
}
