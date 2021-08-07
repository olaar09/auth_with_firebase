import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sealed_unions/sealed_unions.dart';

class ForgotPasswordState extends Union4Impl<_ForgotInitial, _ForgotLoading,
    _ForgotLoaded, _ForgotError> {
  // PRIVATE low-level factory
  // Used for instantiating individual "subclasses"
  static final Quartet<_ForgotInitial, _ForgotLoading, _ForgotLoaded,
          _ForgotError> _factory =
      const Quartet<_ForgotInitial, _ForgotLoading, _ForgotLoaded,
          _ForgotError>();

  // PRIVATE constructor which takes in the individual weather states
  ForgotPasswordState._(
      Union4<_ForgotInitial, _ForgotLoading, _ForgotLoaded, _ForgotError> union)
      : super(union);

  // PUBLIC factories which hide the complexity from outside classes
  factory ForgotPasswordState.initial() =>
      ForgotPasswordState._(_factory.first(_ForgotInitial()));

  factory ForgotPasswordState.loading() =>
      ForgotPasswordState._(_factory.second(_ForgotLoading()));

  factory ForgotPasswordState.loaded() =>
      ForgotPasswordState._(_factory.third(_ForgotLoaded()));

  factory ForgotPasswordState.error(
          {String generic = '', String email = '', String password = ''}) =>
      ForgotPasswordState._(_factory.fourth(_ForgotError(
        passwordError: password,
        emailError: email,
        genericError: generic,
      )));
}

class _ForgotInitial extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _ForgotLoading extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _ForgotLoaded extends Equatable {
  _ForgotLoaded();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _ForgotError extends Equatable {
  final String? emailError;
  final String? passwordError;
  final String? genericError;

  _ForgotError(
      {required this.passwordError,
      required this.emailError,
      this.genericError});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
