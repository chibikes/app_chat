import 'package:app_chat/blocs/authentication_blocs/authentication_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  context
                          .read<AuthenticationBloc>()
                          .state
                          .user
                          .avatarUrl
                          .isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              CachedNetworkImageProvider(state.user.avatarUrl),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              AssetImage('assets/profile_avatar.png'),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 0.7 * MediaQuery.of(context).size.width,
                          child: TextField(
                            onChanged: (name) {},
                            decoration: const InputDecoration(
                              hintText: 'Enter new user name',
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueGrey,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Column(
                        children: [
                          const Text('Phone'),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            context
                                .read<AuthenticationBloc>()
                                .state
                                .user
                                .phoneNumber,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                    child: IconButton(
                        tooltip: 'Log out',
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(LogOut());
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.logout)),
                  ),
                  const Text(
                    'Sign out',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              Positioned(
                top: 60,
                left: (MediaQuery.of(context).size.width * 0.4) + 40,
                child: IconButton(
                  onPressed: () {
                    _openCameraDialog(context);
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void _openCameraDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0))),
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Select Photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0.0),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(UpdateProfilePhoto(
                          color: Theme.of(context).primaryColor));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text('Take a Photo'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24.0),
                          ),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(UpdateProfilePhoto(
                          getImageFromCamera: false,
                          color: Theme.of(context).primaryColor));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            'Select from gallery',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
