import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:app_chat/screens/home/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'conversation.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
        return ListView.builder(
            itemCount: state.recentMessages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.read<MessagesBloc>().add(GetUserMessages(
                        chatId: state.recentMessages[index].receiverId,
                      ));
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const MessageDetail();
                  })));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage('assets/profile_avatar.png'),
                      ),
                      Column(
                        children: [
                          const Text(
                            'name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(state.recentMessages[index].content),
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
