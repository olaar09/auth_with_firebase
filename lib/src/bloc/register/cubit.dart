import 'package:bloc/bloc.dart';

import 'state.dart';

class RegisterCubit extends Cubit<registerState> {
  RegisterCubit() : super(registerState().init());
}
