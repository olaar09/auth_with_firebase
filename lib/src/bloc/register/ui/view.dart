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
  final Future Function({required User user, required String phone})? onSignUp;
  final FirebaseAuth firebaseAuth;

  RegisterPage({this.onSignUp, required this.firebaseAuth});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterCubit _registerCubit;

  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _phoneTextController = TextEditingController();

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
    InheritParameters? params = InheritParameters.of(context);
    return Row(
      children: [
        Expanded(
          child: primaryButton('Create account', context: context,
              onPressed: () async {
            registerCubit.fireRegisterEvent(
              email: _emailTextController.text,
              name: _nameTextController.text,
              password: _passwordTextController.text,
              phone: _phoneTextController.text,
              onSignUp: widget.onSignUp ?? params?.onSignUp,
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext buildContext) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              boldText(
                'Welcome !',
                size: 24,
                color: colorFromHex('6D38FF'),
              ),
              SizedBox(height: 20),
              BlocConsumer<RegisterCubit, RegisterState>(
                bloc: _registerCubit,
                listener: (context, state) {
                  state.join(
                    (initial) => null,
                    (loading) => '',
                    (loaded) {},
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
                          mTextField('Full Name',
                              onChanged: (text) {},
                              hintText: 'As shown on your BVN / NIN or ID card',
                              controller: _nameTextController,
                              error: state.join(
                                (initial) => null,
                                (loading) => '',
                                (loaded) => null,
                                (error) => error.name,
                              )),
                          mTextField('Email address',
                              onChanged: (text) {},
                              hintText: 'Email address',
                              controller: _emailTextController,
                              error: state.join(
                                (initial) => null,
                                (loading) => '',
                                (loaded) => null,
                                (error) => error.emailError,
                              )),
                          mTextField('Phone number',
                              onChanged: (text) {},
                              hintText: 'Phone number',
                              controller: _phoneTextController,
                              error: state.join(
                                (initial) => null,
                                (loading) => '',
                                (loaded) => null,
                                (error) => error.phoneError,
                              )),
                          mTextField('Password',
                              isPassword: true,
                              hintText: 'Password',
                              onChanged: (text) {},
                              controller: _passwordTextController,
                              error: state.join(
                                (initial) => null,
                                (loading) => '',
                                (loaded) => null,
                                (error) => error.passwordError,
                              )),
                          SizedBox(height: 40.0),
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

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _phoneTextController.dispose();

    super.dispose();
  }
}
