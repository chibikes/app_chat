import 'package:app_chat/consts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.automaticallyDetectSMS) {
          showProgressDialog(context);
        }

        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            state.errorMessage,
            style: const TextStyle(color: Colors.black),
          )));
          context.read<LoginCubit>().intializeForm();
        }
        if (state.status.isSubmissionSuccess) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          if (state.country.isEmpty) {
            context.read<LoginCubit>().updateCountry(countryCodes.keys.first);
          }
          return state.codeSent
              ? Column(
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Verifying Phone Number',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: _OTPInput()),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Text('Enter the 6 digit code sent to your device'),
                    const SizedBox(
                      height: 24.0,
                    ),
                    _LoginButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Email'),
                    ),
                    _EmailInput(),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Password'),
                    ),
                    _PasswordInput(),
                    const SizedBox(height: 8.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Enter your phone number'),
                    ),
                    _CountryInput(),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _PhoneCodeContainer(),
                        SizedBox(
                            height: 70,
                            width: 0.70 * MediaQuery.of(context).size.width,
                            child: _PhoneNumber()),
                      ],
                    ),
                    Center(child: _LoginButton()),
                  ],
                );
        }),
      ),
    );
  }
}

class _OTPInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return OTPTextField(
          fieldStyle: FieldStyle.underline,
          length: 6,
          onChanged: (otp) => context.read<LoginCubit>().otpChanged(otp.trim()),
          keyboardType: TextInputType.number,
          onCompleted: (val) {
            context.read<LoginCubit>().logInWithCredentials();
          },
        );
      },
    );
  }
}

class _PhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.phone,
          key: const Key('loginForm_phoneInput_textField'),
          // inputFormatters: [],
          onChanged: (phoneNumber) =>
              context.read<LoginCubit>().phoneNumberChanged(phoneNumber),
          decoration: const InputDecoration(
            labelText: 'Enter Phone Number',
            helperText: '',
            errorText: null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginCubit>().emailChanged(email.trim()),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'e.g. abc@xyz.com',
            labelText: 'Enter your email...',
            helperText: '',
            errorText: state.email.invalid ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscurePassword != current.obscurePassword,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: state.obscurePassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                context.read<LoginCubit>().toggleVisibility();
              },
            ),
            labelText: 'Enter password',
            helperText: '',
            errorText: state.password.invalid
                ? 'password must be 8 characters or more'
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress && !state.codeSent
            ? SizedBox(
                height: 62,
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.white),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Theme.of(context).primaryColor))),
                  onPressed: () {},
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.codeSent ? 'Log In' : 'Continue',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const SizedBox(
                              height: 10.0,
                              width: 10.0,
                              child: CircularProgressIndicator()),
                        ]),
                  ),
                ),
              )
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: () =>
                    context.read<LoginCubit>().logInWithCredentials(),
                child: Text(
                  state.codeSent ? 'Log In' : 'Continue',
                  style: const TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}

class _CountryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.country != current.country,
      builder: (context, state) {
        return DropdownButtonFormField(
          value: countryCodes.keys.first,
          icon: const Icon(Icons.keyboard_arrow_down_sharp),
          iconEnabledColor: Colors.grey,
          items: countryCodes.keys
              .toList()
              .map((country) =>
                  DropdownMenuItem(value: country, child: Text(country)))
              .toList(),
          key: const Key('loginForm_countryInput_textField'),
          onChanged: (country) =>
              context.read<LoginCubit>().updateCountry(country.toString()),
          decoration: const InputDecoration(
            labelText: 'Choose Your Country',
            helperText: '',
          ),
        );
      },
    );
  }
}

class _PhoneCodeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.country != current.country,
      builder: (context, state) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(countryCodes[state.country] ?? ''),
          ),
        );
      },
    );
  }
}

void showProgressDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
        if (!state.automaticallyDetectSMS) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [
                  SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Detecting SMS'),
                ]),
              ),
            ),
          ),
        );
      });
    },
  );
}
