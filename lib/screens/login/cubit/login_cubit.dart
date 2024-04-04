import 'dart:io';
import 'package:app_chat/consts.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/form_models/email.dart';
import '../../../models/form_models/password.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthRepository _authenticationRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void otpChanged(String value) {
    emit(state.copyWith(
      otp: value,
    ));
  }

  void phoneNumberChanged(String value) {
    emit(state.copyWith(
      phoneNumber: value,
      // status: Formz.validate([password]),
    ));
  }

  Future<void> logInWithCredentials() async {
    // if (!state.status.isValid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      if (state.password.invalid && state.email.invalid) {
        return;
      }
      await _authenticationRepository.signUpToSupaBase(
          email: state.email.value, password: state.password.value);
      if (state.autoTimeOut == true ||
          (!Platform.isAndroid && state.codeSent)) {
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: state.verificationId, smsCode: state.otp);
        await _authenticationRepository.signIn(credential,
            email: state.email.value, password: state.password.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        var numberUnit = countryCodes[state.country];
        await _firebaseAuth.verifyPhoneNumber(
            phoneNumber: '$numberUnit${state.phoneNumber}',
            verificationCompleted: (cred) {
              // auto sms resolution that works only on Android devices
              _authenticationRepository.signIn(
                cred,
                email: state.email.value,
                password: state.password.value,
              );
              emit(state.copyWith(status: FormzStatus.submissionSuccess));
            },
            verificationFailed: (e) {
              emit(state.copyWith(
                  status: FormzStatus.submissionFailure,
                  errorMessage: 'Could not verify phone number'));
            },
            codeSent: (verificationId, resendToken) {
              emit(state.copyWith(
                  codeSent: true,
                  verificationId: verificationId,
                  automaticallyDetectSMS: Platform.isAndroid));
            },
            codeAutoRetrievalTimeout: (id) {
              // fires when auto detect times out
              emit(state.copyWith(
                  autoTimeOut: true,
                  verificationId: id,
                  automaticallyDetectSMS: false));
            });
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, errorMessage: e.message));
    } on SocketException {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Check your internet connection and try again'));
    } on Exception {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Connection failed. Try again'));
    }
  }

  void stopFormSubmission() {
    emit(state.copyWith(status: FormzStatus.submissionCanceled));
  }

  void intializeForm() {
    emit(state.copyWith(status: FormzStatus.pure));
  }

  updateCountry(String country) {
    emit(state.copyWith(country: country));
    _authenticationRepository.setPhoneCode(countryCodes[country] ?? '');
  }

  emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  void toggleVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password]),
    ));
  }
}
