import 'package:auth_with_firebase/src/bloc/forgot_password/ui/view.dart';
import 'package:auth_with_firebase/src/bloc/login/state.dart';
import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:auth_with_firebase/src/utils/widgets/inherit_parameters.dart';
import 'package:auth_with_firebase/src/utils/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth_with_firebase.dart';
import '../cubit.dart';

class SignInPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;

  final Function({required User user}) onSignIn;
  final Function onRequested;
  final Function? onContinueAsGuest;
  final Function({required User user, String phoneNumber}) onSignUp;

  SignInPage({
    required this.onSignIn,
    required this.onSignUp,
    required this.onRequested,
    required this.firebaseAuth,
    this.onContinueAsGuest,
  });

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final SignInCubit _authBloc;

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  @override
  void initState() {
    _authBloc = SignInCubit(
        fireAuthRepo: FireAuthRepo(firebaseAuth: widget.firebaseAuth));
    super.initState();
  }

  actionButtons(context, SignInCubit _authBloc) {
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
                  _authBloc.fireLoginAttempt(
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
                            forgotRequested: widget.onRequested,
                            child: ForgotPasswordPage(
                              firebaseAuth: widget.firebaseAuth,
                            ),
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
                            onSignUp: widget.onSignUp,
                            child: RegisterPage(
                              firebaseAuth: widget.firebaseAuth,
                            ),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: leadingBtn(buildContext),
        backgroundColor: Colors.white,
        actions: [
          widget.onContinueAsGuest == null
              ? Container()
              : TextButton(
                  onPressed: () => widget.onContinueAsGuest!(),
                  child: Text('Continue as guest'),
                )
        ],
      ),
      //  backgroundColor: Vl.color(color: MColor.K_LIGHT_PLAIN),
      body: BlocConsumer<SignInCubit, LoginState>(
        bloc: _authBloc,
        listener: (context, state) {
          state.join((initial) => null, (loading) => null, (loaded) {
            print('sign in complete, next action here');
            widget.onSignIn(user: loaded.user);
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
                      height: 18.0,
                    ),
                    state.join(
                      (initial) => actionButtons(context, _authBloc),
                      (loading) => networkActivityIndicator(),
                      (loaded) => actionButtons(context, _authBloc),
                      (error) => actionButtons(context, _authBloc),
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
