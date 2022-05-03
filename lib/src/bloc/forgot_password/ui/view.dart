import 'package:auth_with_firebase/src/bloc/forgot_password/state.dart';
import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:auth_with_firebase/src/utils/widgets/inherit_parameters.dart';
import 'package:auth_with_firebase/src/utils/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;
  final Function? onRequested;

  ForgotPasswordPage({this.onRequested, required this.firebaseAuth});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailTextController = TextEditingController();

  final bool isForgotSent = false;

  actionButtons(context, ForgotPasswordCubit forgotBloc) {
    return Container(
      // height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: primaryButton('Reset password',
                    context: context, vertical: 14, onPressed: () async {
                  forgotBloc.fireResetRequest(
                    email: _emailTextController.text,
                  );
                }),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    ForgotPasswordCubit forgotBloc = ForgotPasswordCubit(
        repo: FireAuthRepo(firebaseAuth: widget.firebaseAuth));
    InheritParameters? params = InheritParameters.of(buildContext);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: leadingBtn(buildContext),
        backgroundColor: Colors.white,
      ),
      //  backgroundColor: Vl.color(color: MColor.K_LIGHT_PLAIN),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        bloc: forgotBloc,
        listener: (context, state) {
          state.join(
            (initial) => null,
            (loading) => null,
            (loaded) {},
            (error) {
              if (error.genericError != null && error.genericError!.length > 0)
                mSnackBar(context: buildContext, message: error.genericError);
            },
          );
        },
        builder: (context, state) {
          return state.join(
            (initial) => buildForm(state, context, forgotBloc),
            (loading) => buildForm(state, context, forgotBloc),
            (loaded) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Password reset instruction has been sent to your email (${_emailTextController.text})',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  primaryButton('Continue', context: context, vertical: 14,
                      onPressed: () async {
                    if (widget.onRequested != null)
                      widget.onRequested!();
                    else
                      params?.forgotRequested!();
                  })
                ],
              ),
            ),
            (error) => buildForm(state, context, forgotBloc),
          );
        },
      ),
    );
  }

  Padding buildForm(ForgotPasswordState state, BuildContext context,
      ForgotPasswordCubit forgotBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Form(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                boldText('Forgot password'),
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
            SizedBox(
              height: 18,
            ),
            state.join(
              (initial) => actionButtons(context, forgotBloc),
              (loading) => networkActivityIndicator(),
              (loaded) => actionButtons(context, forgotBloc),
              (error) => actionButtons(context, forgotBloc),
            ),
          ],
        ),
      ),
    );
  }
}
