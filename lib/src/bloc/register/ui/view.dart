import 'package:auth_with_firebase/src/bloc/login/state.dart';
import 'package:auth_with_firebase/src/bloc/register/state.dart';
import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:auth_with_firebase/src/utils/widgets/inherit_parameters.dart';
import 'package:auth_with_firebase/src/utils/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth_with_firebase.dart';
import '../cubit.dart';

class RegisterPage extends StatefulWidget {
  final Function({required User user, String? phoneNumber})? onSignUp;
  final FirebaseAuth firebaseAuth;

  RegisterPage({this.onSignUp, required this.firebaseAuth});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterCubit _registerCubit;

  final _registerFormKey = GlobalKey<FormState>();

  final _phoneTextController = TextEditingController();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusPhone = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  @override
  void initState() {
    _registerCubit =
        RegisterCubit(repo: FireAuthRepo(firebaseAuth: widget.firebaseAuth));
    super.initState();
  }

  actionButton(RegisterCubit registerCubit, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: primaryButton('Sign Up', context: context, vertical: 14,
              onPressed: () async {
            registerCubit.fireRegisterEvent(
                //  firstName: _firstNameTextController.text,
                email: _emailTextController.text,
                // lastName: _lastNameTextController.text,
                phone: _phoneTextController.text,
                // bvn: _bvnTextController.text,
                password: _passwordTextController.text);
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    InheritParameters params = InheritParameters.of(context);

    return GestureDetector(
      onTap: () {
        _focusPhone.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: leadingBtn(context),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldText('Create account'),
                ],
              ),
              SizedBox(height: 10),
              BlocConsumer<RegisterCubit, RegisterState>(
                bloc: _registerCubit,
                listener: (context, state) {
                  state.join(
                    (initial) => null,
                    (loading) => '',
                    (loaded) {
                      if (widget.onSignUp != null) {
                        widget.onSignUp!(
                            user: loaded.user,
                            phoneNumber: _phoneTextController.text);
                      } else {
                        params.onSignUp!(
                          user: loaded.user,
                          phoneNumber: _phoneTextController.text,
                        );
                      }
                    },
                    (error) {
                      if (error.genericError != null &&
                          error.genericError!.length > 0)
                        mSnackBar(
                            context: buildContext, message: error.genericError);
                    },
                  );
                },
                builder: (context, state) {
                  return Form(
                    key: _registerFormKey,
                    child: Expanded(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 8.0),
                          mTextField('Phone Number',
                              onChanged: (text) {},
                              controller: _phoneTextController,
                              error: state.join(
                                (initial) => null,
                                (loading) => '',
                                (loaded) => null,
                                (error) => error.phoneError,
                              )),
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
                          SizedBox(height: 18.0),
                          state.join(
                            (initial) => actionButton(_registerCubit, context),
                            (loading) => networkActivityIndicator(),
                            (loaded) => actionButton(_registerCubit, context),
                            (error) => actionButton(_registerCubit, context),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
