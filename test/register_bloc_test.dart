import 'package:auth_with_firebase/src/bloc/register/state.dart';
import 'package:auth_with_firebase/src/repo/fire_auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'package:auth_with_firebase/auth_with_firebase.dart';

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

class MockFirebaseRepo extends Mock implements FireAuthRepo {}

void main() {
  // MockRegisterCubit registerBloc;
  print('tests coming soon');
}
