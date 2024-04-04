import 'package:app_chat/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageDetail extends StatefulWidget {
  const MessageDetail(
      {super.key, required this.chatName, required this.avatarUrl});
  final String chatName;
  final String avatarUrl;

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  final ScrollController _scrollController = ScrollController();
  List _changePoints = [];

  @override
  void initState() {
    _changePoints =
        getChangePoints(context.read<MessagesBloc>().state.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String message = '';
    return BlocConsumer<MessagesBloc, MessagesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            title: Row(children: [
              widget.avatarUrl.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(widget.avatarUrl),
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage('assets/profile_avatar.png'),
                    ),
              const SizedBox(
                width: 5.0,
              ),
              Text(widget.chatName)
            ]),
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: state.messages.length,
                itemBuilder: ((context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        _changePoints.contains(index)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                    child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(getFormattedDate(
                                        state.messages[index].timeStamp)),
                                  ),
                                )),
                              )
                            : const SizedBox(),
                        BubbleSpecialThree(
                          sent: state.messages[index].senderId ==
                              Supabase.instance.client.auth.currentUser?.id,
                          color: state.messages[index].senderId ==
                                  Supabase.instance.client.auth.currentUser?.id
                              ? Colors.green
                              : Colors.white,
                          text: state.messages[index].content,
                          isSender: state.messages[index].senderId ==
                              Supabase.instance.client.auth.currentUser?.id,
                        ),
                        Align(
                          alignment: state.messages[index].senderId ==
                                  Supabase.instance.client.auth.currentUser?.id
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0),
                            child: Text(
                              convertDateTime(state.messages[index].timeStamp),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
          ),
          bottomSheet: BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Padding(
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
                                      context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user
                                          .userId,
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
                );
              }),
        );
      },
      listener: (context, state) {
        _changePoints = getChangePoints(state.messages);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.position.pixels !=
              _scrollController.position.maxScrollExtent) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      },
      listenWhen: ((previous, current) =>
          previous.messages != current.messages),
    );
  }
}

String convertDateTime(
  String dateTime,
) {
  final dtime = DateTime.tryParse(dateTime)?.toLocal();
  if (dtime == null) return '';
  return '${dtime.hour} : ${dtime.minute}';
}

String getFormattedDate(String dateTime) {
  final dtime = DateTime.tryParse(dateTime)?.toLocal();
  if (dtime == null) return '';
  DateFormat dateFormat = DateFormat('E, MMM, yyyy');
  return dateFormat.format(dtime);
}

List<int> getChangePoints(List<Message> messages) {
  List<int> changePoints = [0]; // Initialize with the first message index

  for (int i = 1; i < messages.length; i++) {
    DateTime currentDate = DateTime.parse(messages[i].timeStamp);
    DateTime previousDate = DateTime.parse(messages[i - 1].timeStamp);

    if (DateTime(currentDate.year, currentDate.month, currentDate.day) !=
        DateTime(previousDate.year, previousDate.month, previousDate.day)) {
      changePoints.add(i); // Add the index where the date changes
    }
  }

  return changePoints;
}
