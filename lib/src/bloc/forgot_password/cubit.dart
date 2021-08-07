import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordState.initial());
  FireAuthRepo _repo = FireAuthRepo();

  Future fireResetRequest({required String email}) async {
    try {
      emit(ForgotPasswordState.loading());

      if (email.length < 1) {
        this.emit(
            ForgotPasswordState.error(email: ' Enter your email address'));
        throw Exception('Enter your email address');
      }

      await _repo.requestPasswordReset(email).timeout(Duration(seconds: 60),
          onTimeout: () {
        throw Exception('timed out');
      });
      emit(ForgotPasswordState.loaded());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        this.emit(ForgotPasswordState.error(generic: 'Email  incorrect'));
      }
    } catch (e) {
      print(e.toString());
      this.emit(ForgotPasswordState.error(
          generic: 'An unknown error happened.  check your internet'));
    }
  }
}
