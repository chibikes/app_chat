import 'dart:async';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../image_selector.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  StreamSubscription? _userSubscription;
  final ImageSelector _imageSelector = ImageSelector();

  AuthenticationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const Uninitialized(UnverifiedUser())) {
    _userSubscription = _authRepository.getUser().listen((event) {
      add(AuthenticationUserChanged(event));
    });

    on<AuthenticationUserChanged>((event, emit) {
      emit(event.user is! UnverifiedUser
          ? Authenticated(event.user)
          : Unauthenticated(event.user));
    });

    on<LogOut>((event, emit) async {
      Future.wait(
        [_authRepository.logOut()],
      );
    });

    on<UpdateUser>((event, emit) => _authRepository.updateUserInfo());

    on<UpdateProfilePhoto>((event, emit) async {
      var filePath = '';
      if (event.getImageFromCamera) {
        filePath = await _imageSelector.getImageFromCamera(event.color);
      } else {
        filePath = await _imageSelector.getImageFromGallery(event.color);
      }
      _authRepository.uploadPhoto(filePath);
    });
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await _authRepository.cancelSubscriptions();
    return super.close();
  }
}
