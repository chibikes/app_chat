part of 'login_cubit.dart';

class LoginState extends Equatable {
  final AppUser user;
  final String errorMessage;
  final Email email;
  final Password password;
  final String phoneNumber;
  final bool obscurePassword;
  final String otp;
  final FormzStatus status;
  final bool codeSent;
  final bool autoTimeOut;
  final String verificationId;
  final String country;
  final bool automaticallyDetectSMS;

  const LoginState({
    this.user = const UnverifiedUser(),
    this.errorMessage = '',
    this.phoneNumber = '',
    this.otp = '',
    this.obscurePassword = true,
    this.verificationId = '',
    this.password = const Password.pure(),
    this.autoTimeOut = false,
    this.email = const Email.pure(),
    this.automaticallyDetectSMS = false,
    this.status = FormzStatus.pure,
    this.codeSent = false,
    this.country = '',
  });

  LoginState copyWith({
    AppUser? user,
    bool? obscurePassword,
    String? errorMessage,
    Password? password,
    String? phoneNumber,
    String? otp,
    Email? email,
    bool? automaticallyDetectSMS,
    FormzStatus? status,
    String? verificationId,
    bool? codeSent,
    bool? autoTimeOut,
    String? country,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      codeSent: codeSent ?? this.codeSent,
      autoTimeOut: autoTimeOut ?? this.autoTimeOut,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      country: country ?? this.country,
      automaticallyDetectSMS:
          automaticallyDetectSMS ?? this.automaticallyDetectSMS,
    );
  }

  @override
  List<Object?> get props => [
        user,
        errorMessage,
        email,
        password,
        codeSent,
        obscurePassword,
        status,
        autoTimeOut,
        verificationId,
        phoneNumber,
        otp,
        country,
        automaticallyDetectSMS
      ];
}
