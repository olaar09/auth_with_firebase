import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sealed_unions/sealed_unions.dart';

class LoginState extends Union4Impl<_LoginInitial, _LoginLoading, _LoginLoaded,
    _LoginError> {
  // PRIVATE low-level factory
  // Used for instantiating individual "subclasses"
  static final Quartet<_LoginInitial, _LoginLoading, _LoginLoaded, _LoginError>
      _factory =
      const Quartet<_LoginInitial, _LoginLoading, _LoginLoaded, _LoginError>();

  // PRIVATE constructor which takes in the individual weather states
  LoginState._(
      Union4<_LoginInitial, _LoginLoading, _LoginLoaded, _LoginError> union)
      : super(union);

  // PUBLIC factories which hide the complexity from outside classes
  factory LoginState.initial() => LoginState._(_factory.first(_LoginInitial()));

  factory LoginState.loading() =>
      LoginState._(_factory.second(_LoginLoading()));

  factory LoginState.loaded({required User user}) =>
      LoginState._(_factory.third(_LoginLoaded(user: user)));

  factory LoginState.error(
          {String generic = '', String email = '', String password = ''}) =>
      LoginState._(_factory.fourth(_LoginError(
        passwordError: password,
        emailError: email,
        genericError: generic,
      )));
}

class _LoginInitial extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _LoginLoading extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _LoginLoaded extends Equatable {
  final User user;

  _LoginLoaded({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _LoginError extends Equatable {
  final String? emailError;
  final String? passwordError;
  final String? genericError;

  _LoginError(
      {required this.passwordError,
      required this.emailError,
      this.genericError});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
