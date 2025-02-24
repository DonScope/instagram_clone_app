import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/helpers/generate_chat_id.dart';
import 'package:instagram_clone_app/core/helpers/navigation_helper.dart';
import 'package:instagram_clone_app/core/web_services/chat_service.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/chat_repository.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/presentation/auth/widgets/custom_text_form_field.dart';
import 'package:instagram_clone_app/presentation/chat/cubit/chat_cubit.dart';
import 'package:instagram_clone_app/presentation/chat/ui/chat_screen.dart';
import 'package:instagram_clone_app/presentation/search/cubit/search_cubit.dart';
import 'package:instagram_clone_app/shared_widgets/vertical_spacer.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (context) =>
                SearchCubit(UserRepository(UserService()))..fetchAllUsers(),
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                final cubit = SearchCubit.get(context);
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchSuccess) {
                  return Column(
                    children: [
                      CustomTextField(
                        labelText: "Search",
                        prefix: const Icon(Icons.search),
                        onChanged: (value) {
                          cubit.search(value);
                        },
                      ),
                      VerticalSpacer(),
                      Text("Messages"),
                      VerticalSpacer(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return GestureDetector(
                              onTap: () async {
                                String currentUserId =
                                    CacheHelper.getData(key: "uId");
                                String chatId =
                                    generateChatId(currentUserId, user.uId!);

                                await cubit.createChatIfNotExists(
                                  chatId: chatId,
                                  participants: [currentUserId, user.uId!],
                                );

                                NavigationHelper.goTo(
                                    context,
                                    BlocProvider(
                                      create: (context) => ChatCubit(
                                          ChatRepository(ChatService()))
                                        ..listenToMessages(chatId),
                                      child: ChatScreen(
                                          otherUserName: user.name!,
                                          fcmToken: user.fcmToken!,
                                          chatId: chatId,
                                          currentUserId: currentUserId),
                                    ));
                              },
                              child: ListTile(
                                title: Text(user.name!),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profilePicUrl!),
                                ),
                                trailing:
                                    const Icon(Icons.arrow_drop_up_outlined),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (state is SearchError) {
                  return Center(child: Text("error, Please try again later!"));
                }
                return const Center(
                  child: Text("List is empty."),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
