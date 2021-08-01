import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit.dart';
import '../state.dart';

class RegisterPage extends StatelessWidget {
  final cubit = RegisterCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('hello world'),
      ),
    );
  }
}
