import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  FireAuthRepo _repo;

  RegisterCubit({FireAuthRepo? repo})
      : _repo = repo ?? FireAuthRepo(),
        super(RegisterState.initial());

  Future fireRegisterEvent(
      {required String email,
      required String password,
      required String phone}) async {
    try {
      emit(RegisterState.loading());

      if (phone.length < 1) {
        this.emit(RegisterState.error(phoneError: ' Enter your phone number'));
        throw Exception('Enter your phone number');
      }

      if (email.length < 1) {
        this.emit(RegisterState.error(email: ' Enter your email address'));
        throw Exception('Enter your email address');
      }

      if (password.length < 1) {
        this.emit(RegisterState.error(password: ' Enter your password'));
        throw Exception('Enter your password');
      }

      User? user;

      UserCredential userCredential = await _repo
          .signUp(email: email, password: password)
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw Exception('timed out');
      });
      user = userCredential.user;
      emit(RegisterState.loaded(user: user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        this.emit(RegisterState.error(generic: 'Email already exist'));
      } else if (e.code == 'wrong-password') {
        this.emit(RegisterState.error(generic: 'Email or password incorrect'));
      } else {
        this.emit(RegisterState.error(
            generic: 'An error occurred, please try again later'));
      }
    } catch (e) {
      this.emit(RegisterState.error(
          generic: 'An unknown error happened.  check your internet'));
    }
  }
}
