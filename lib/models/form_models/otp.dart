import 'package:formz/formz.dart';

enum OtpValidationError { invalid }

class OTP extends FormzInput<String, OtpValidationError> {
  const OTP.pure() : super.pure('');
  const OTP.dirty([String value = '']) : super.dirty(value);

  static final RegExp _otpRegExp = RegExp(r'^\d{5}$');

  @override
  OtpValidationError? validator(String value) {
    return value.isNotEmpty && _otpRegExp.hasMatch(value)
        ? null
        : OtpValidationError.invalid;
  }
}
