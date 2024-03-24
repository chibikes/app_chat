part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  final AppUser user;
  const AuthenticationState(this.user);
  @override
  List<Object> get props => [user];
}

class Uninitialized extends AuthenticationState {
  const Uninitialized(AppUser user) : super(user);
}

class Authenticated extends AuthenticationState {
  const Authenticated(AppUser user) : super(user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { userId: $user }';
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated(AppUser user) : super(user);
}
