import 'package:app_chat/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:app_chat/blocs/messages_bloc/messages_state.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'conversation.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  bool showSearchBar = false;
  List<Contact> searchedContacts = [];
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
                          final displayName = element.displayName ?? '',
                              givenName = element.givenName ?? '',
                              surname = element.familyName ?? '';
                          return (displayName.contains(RegExp(
                                  value.replaceAll(" ", ""),
                                  caseSensitive: false))) ||
                              givenName.contains(RegExp(
                                  value.replaceAll(" ", ""),
                                  caseSensitive: false)) ||
                              surname.contains(RegExp(value.replaceAll(" ", ""),
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
                                  phone: state.contacts[index].phones?.first
                                          .value ??
                                      '',
                                ),
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return const MessageDetail();
                              }),
                            ),
                          );
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
                                  Text(
                                    state.contacts[index].displayName ??
                                        'Unknown user',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(state.contacts[index].phones?.first
                                          .value ??
                                      'Unknown user'),
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
                          context.read<MessagesBloc>().add(
                                GetContactUserId(
                                  phone: searchedContacts[index]
                                          .phones
                                          ?.first
                                          .value ??
                                      '',
                                ),
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return const MessageDetail();
                              }),
                            ),
                          );
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
                                  Text(
                                    searchedContacts[index].displayName ??
                                        'Unknown',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(searchedContacts[index]
                                          .phones
                                          ?.first
                                          .value ??
                                      'Unknown'),
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
