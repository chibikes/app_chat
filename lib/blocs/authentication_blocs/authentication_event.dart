part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  final AppUser user;
  AuthenticationUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class LogOut extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class UpdateProfilePhoto extends AuthenticationEvent {
  final bool getImageFromCamera;
  final Color color;

  UpdateProfilePhoto({this.getImageFromCamera = true, required this.color});

  @override
  List<Object?> get props => [];
}

class UpdateUser extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}
