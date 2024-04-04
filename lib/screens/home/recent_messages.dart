import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:app_chat/screens/home/contacts_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'conversation.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
        if (state.fetchState == MessageFetchState.fetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: state.recentMessages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.read<MessagesBloc>().add(UpdateChatId(
                        chatId: state.recentMessages[index].chatUser.userId,
                      ));
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return MessageDetail(
                      chatName: state.recentMessages[index].chatUser.fullName,
                      avatarUrl: state.recentMessages[index].chatUser.avatarUrl,
                    );
                  })));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state.recentMessages[index].chatUser.avatarUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(state
                                  .recentMessages[index].chatUser.avatarUrl),
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage('assets/profile_avatar.png'),
                            ),
                      Column(
                        children: [
                          Text(
                            state.recentMessages[index].chatUser.fullName
                                    .isNotEmpty
                                ? state.recentMessages[index].chatUser.fullName
                                : state
                                    .recentMessages[index].chatUser.phoneNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.recentMessages[index].content,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(state.recentMessages[index].date),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const ContactsPage();
          }));
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
