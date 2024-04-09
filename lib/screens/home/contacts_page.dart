import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'conversation.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key, required this.callContact});
  final bool callContact;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool showSearchBar = false;
  List<AppUser> searchedContacts = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: showSearchBar
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          toolbarHeight: 80,
          title: showSearchBar
              ? SizedBox(
                  width: showSearchBar
                      ? 0.8 * MediaQuery.of(context).size.width
                      : 0,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchedContacts = state.contacts.where((element) {
                          return element.fullName.contains(RegExp(
                              value.replaceAll(" ", ""),
                              caseSensitive: false));
                        }).toList();
                      });
                    },
                  ),
                )
              : const Text('Select Contact'),
          actions: [
            IconButton(
                onPressed: () {
                  if (!showSearchBar) {
                    setState(() {
                      showSearchBar = true;
                    });
                  }
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Stack(
          children: [
            searchedContacts.isEmpty
                ? ListView.builder(
                    itemCount: state.contacts.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () async {
                          context.read<MessagesBloc>().add(
                                GetContactUserId(
                                    phone: state.contacts[index].phoneNumber),
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return MessageDetail(
                                  chatName: state.contacts[index].fullName,
                                  avatarUrl: state.contacts[index].avatarUrl,
                                );
                              }),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              state.contacts[index].avatarUrl.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          state.contacts[index].avatarUrl),
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                          'assets/profile_avatar.png'),
                                    ),
                              Column(
                                children: [
                                  Text(
                                    state.contacts[index].fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(state.contacts[index].phoneNumber),
                                ],
                              ),
                              const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }))
                : ListView.builder(
                    itemCount: searchedContacts.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () async {
                          widget.callContact
                              ? {
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(builder: ((context) {
                                  //   return const NewCall();
                                  // })))
                                }
                              : context.read<MessagesBloc>().add(
                                    GetContactUserId(
                                      phone:
                                          searchedContacts[index].phoneNumber,
                                    ),
                                  );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return MessageDetail(
                                  chatName: state.contacts[index].fullName,
                                  avatarUrl: state.contacts[index].avatarUrl,
                                );
                              }),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              searchedContacts[index].avatarUrl.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          searchedContacts[index].avatarUrl),
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                          'assets/profile_avatar.png'),
                                    ),
                              Column(
                                children: [
                                  Text(
                                    searchedContacts[index].fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(searchedContacts[index].phoneNumber),
                                ],
                              ),
                              const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ],
        ),
      );
    });
  }
}
