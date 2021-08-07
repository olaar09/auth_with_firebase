import 'package:auth_with_firebase/src/bloc/forgot_password/ui/view.dart';
import 'package:auth_with_firebase/src/bloc/login/state.dart';
import 'package:auth_with_firebase/src/utils/widgets/inherit_parameters.dart';
import 'package:auth_with_firebase/src/utils/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth_with_firebase.dart';

class SignInPage extends StatelessWidget {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  final Function({required User user}) onSignIn;
  final Function onRequested;
  final Function({required User user, String phoneNumber}) onSignUp;

  SignInPage({
    required this.onSignIn,
    required this.onSignUp,
    required this.onRequested,
  });

  actionButtons(context, SignInCubit authBloc) {
    return Container(
      // height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child:
                    primaryButton('Sign In', vertical: 14, onPressed: () async {
                  authBloc.fireLoginAttempt(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  );
                }),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                    child:
                        Text('Reset password', style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InheritParameters(
                            forgotRequested: onRequested,
                            child: ForgotPasswordPage(),
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                child: TextButton(
                    child: Text('Create new account',
                        style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InheritParameters(
                            onSignUp: onSignUp,
                            child: RegisterPage(),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    SignInCubit authBloc = SignInCubit();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: leadingBtn(buildContext),
        backgroundColor: Colors.white,
      ),
      //  backgroundColor: Vl.color(color: MColor.K_LIGHT_PLAIN),
      body: BlocConsumer<SignInCubit, LoginState>(
        bloc: authBloc,
        listener: (context, state) {
          state.join((initial) => null, (loading) => null, (loaded) {
            print('sign in complete, next action here');
            onSignIn(user: loaded.user);
          }, (error) {
            if (error.genericError != null && error.genericError!.length > 0)
              mSnackBar(context: buildContext, message: error.genericError);
          });
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              _focusEmail.unfocus();
              _focusPassword.unfocus();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        boldText('Sign in'),
                      ],
                    ),
                    SizedBox(height: 10),
                    mTextField('Email address',
                        onChanged: (text) {},
                        controller: _emailTextController,
                        error: state.join(
                          (initial) => null,
                          (loading) => '',
                          (loaded) => null,
                          (error) => error.emailError,
                        )),
                    SizedBox(height: 8.0),
                    mTextField('Password',
                        isPassword: true,
                        onChanged: (text) {},
                        controller: _passwordTextController,
                        error: state.join(
                          (initial) => null,
                          (loading) => '',
                          (loaded) => null,
                          (error) => error.passwordError,
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    state.join(
                      (initial) => actionButtons(context, authBloc),
                      (loading) => networkActivityIndicator(),
                      (loaded) => actionButtons(context, authBloc),
                      (error) => actionButtons(context, authBloc),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
