import 'dart:async';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  StreamSubscription? _firebaseUserSubscription;
  StreamSubscription? _supabaseUserSubscription;

  AuthenticationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const Uninitialized(UnverifiedUser())) {
    _supabaseUserSubscription =
        _authRepository.getSupaBaseUser().listen((event) {});

    _firebaseUserSubscription =
        _authRepository.getFirebaseUser().listen((event) {
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

    on<UpdateUser>(
        (event, emit) => _authRepository.updateUser(event.userUpdateCallback));
  }

  @override
  Future<void> close() {
    _firebaseUserSubscription?.cancel();
    _supabaseUserSubscription?.cancel();
    return super.close();
  }
}
