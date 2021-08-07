import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sealed_unions/sealed_unions.dart';

class RegisterState extends Union4Impl<_RegisterInitial, _RegisterLoading,
    _RegisterLoaded, _RegisterError> {
  // PRIVATE low-level factory
  // Used for instantiating individual "subclasses"
  static final Quartet<_RegisterInitial, _RegisterLoading, _RegisterLoaded,
          _RegisterError> _factory =
      const Quartet<_RegisterInitial, _RegisterLoading, _RegisterLoaded,
          _RegisterError>();

  // PRIVATE constructor which takes in the individual weather states
  RegisterState._(
      Union4<_RegisterInitial, _RegisterLoading, _RegisterLoaded,
              _RegisterError>
          union)
      : super(union);

  // PUBLIC factories which hide the complexity from outside classes
  factory RegisterState.initial() =>
      RegisterState._(_factory.first(_RegisterInitial()));

  factory RegisterState.loading() =>
      RegisterState._(_factory.second(_RegisterLoading()));

  factory RegisterState.loaded({required User user}) =>
      RegisterState._(_factory.third(_RegisterLoaded(user: user)));

  factory RegisterState.error({
    String generic = '',
    String email = '',
    String password = '',
    String phoneError = '',
    String p = '',
  }) =>
      RegisterState._(_factory.fourth(_RegisterError(
        passwordError: password,
        emailError: email,
        genericError: generic,
        phoneError: phoneError,

      )));
}

class _RegisterInitial extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _RegisterLoading extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _RegisterLoaded extends Equatable {
  final User user;

  _RegisterLoaded({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class _RegisterError extends Equatable {
  final String? emailError;
  final String? phoneError;
  final String? fError;
  final String? passwordError;
  final String? genericError;

  _RegisterError(
      {required this.passwordError,
      this.phoneError,
      this.fError,
      required this.emailError,
      this.genericError});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
