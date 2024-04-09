// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NewCall extends StatefulWidget {
//   const NewCall({super.key});

//   @override
//   State<NewCall> createState() => _NewCallState();
// }

// class _NewCallState extends State<NewCall> {
//   bool _isJoined = false;
//   late RtcEngine agoraEngine;
//   int? _remoteUid;
//   int uid = 0;
//   String channelName = "test";
//   String token =
//       "";

//   @override
//   void initState() {
//     setupVoiceSDKEngine().then((value) => join()).catchError((err) {
//       print('could not initialize sdk $err');
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(children: [
//         CircleAvatar(
//           backgroundImage: NetworkImage(''),
//         )
//       ]),
//     );
//   }

//   void join() async {
//     // Set channel options including the client role and channel profile
//     ChannelMediaOptions options = const ChannelMediaOptions(
//       clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     );

//     await agoraEngine.joinChannel(
//       token: token,
//       channelId: channelName,
//       options: options,
//       uid: uid,
//     );
//   }

//   Future<void> setupVoiceSDKEngine() async {
//     // retrieve or request microphone permission
//     await [Permission.microphone].request();

//     //create an instance of the Agora engine
//     agoraEngine = createAgoraRtcEngine();
//     await agoraEngine
//         .initialize(RtcEngineContext(appId: dotenv.env['AGORA_APP_ID']));

//     print('successfully initialized agora');

//     // Register the event handler
//     agoraEngine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() async {
//     await agoraEngine.leaveChannel();
//     super.dispose();
//   }
// }
