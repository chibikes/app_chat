import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageDetail extends StatelessWidget {
  const MessageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    String message = '';
    return BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
      return Scaffold(
        body: ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: ((context, index) {
              return BubbleSpecialThree(
                color: state.messages[index].senderId ==
                        Supabase.instance.client.auth.currentUser?.id
                    ? Colors.green
                    : Colors.white,
                text: state.messages[index].content,
                isSender: state.messages[index].senderId ==
                    Supabase.instance.client.auth.currentUser?.id,
              );
            })),
        bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 0.8 * MediaQuery.of(context).size.width,
                        child: TextField(
                          onChanged: (messageValue) {
                            message = messageValue;
                          },
                          decoration: const InputDecoration(
                            labelText: 'message',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<MessagesBloc>().add(SendMessage(
                              message: Message(
                                  timeStamp: '',
                                  content: message,
                                  senderId: Supabase.instance.client.auth
                                          .currentUser?.id ??
                                      '',
                                  receiverId: state.chatId,
                                  date: '')));
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }
}
