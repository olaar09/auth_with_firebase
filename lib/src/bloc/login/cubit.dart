import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class SignInCubit extends Cubit<LoginState> {
  SignInCubit() : super(LoginState.initial());
  FireAuthRepo _repo = FireAuthRepo();

  Future fireLoginAttempt(
      {required String email, required String password}) async {
    try {
      emit(LoginState.loading());

      if (email.length < 1) {
        this.emit(LoginState.error(email: ' Enter your phone number'));
        throw Exception('Enter your phone number');
      }

      if (password.length < 1) {
        this.emit(LoginState.error(password: ' Enter your password'));
        throw Exception('Enter your password');
      }

      User? user;

      UserCredential userCredential = await _repo
          .signInWithCredentials('$email', '$password')
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw Exception('timed out');
      });
      user = userCredential.user;
      emit(LoginState.loaded(user: user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        this.emit(LoginState.error(generic: 'Email or password incorrect'));
      } else if (e.code == 'wrong-password') {
        this.emit(LoginState.error(generic: 'Email or password incorrect'));
      }
    } catch (e) {
      this.emit(LoginState.error(
          generic: 'An unknown error happened.  check your internet'));
    }
  }
}
