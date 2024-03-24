import 'package:app_chat/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_bloc.dart';
import 'package:app_chat/blocs/messages_bloc/messages_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'calls.dart';
import 'recent_messages.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    context.read<MessagesBloc>().add(GetRecentMessages());
    // _tabController.addListener(_handleTabChange);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.all(65.0),
          child: Text(
            'AppChat',
            style: TextStyle(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(Icons.person),
          )
        ],
        toolbarHeight: 20.0,
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Theme.of(context).textTheme.titleLarge!.color,
          indicatorWeight: 3.0,
          labelPadding: const EdgeInsets.symmetric(horizontal: 50.0),
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(
              text: 'Chats',
            ),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: const [
            MessagesScreen(),
            CallsScreen(),
          ],
        ),
      ),
    );
  }
}
