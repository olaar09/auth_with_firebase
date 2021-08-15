import 'package:firebase_auth/firebase_auth.dart';

class FireAuthRepo {
  final FirebaseAuth _firebaseAuth;

  FireAuthRepo({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  FirebaseAuth getAuthInstance() {
    return _firebaseAuth;
  }

  Future requestPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<UserCredential> signInWithCredentials(
      String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(
      {required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> registerUsingEmailPassword(
    String email,
    String password,
  ) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<User?> updateProfile(String name, String phone) async {
    await _firebaseAuth.currentUser!.updateDisplayName(name);
    await _firebaseAuth.currentUser!.reload();
    return _firebaseAuth.currentUser;
  }

  Future<String?> getUID() async {
    if (await isSignedIn())
      try {
        return _firebaseAuth.currentUser!.uid;
      } catch (e) {
        _firebaseAuth.signOut();
      }
  }

  Future<String?> getToken() async {
    if (await isSignedIn())
      try {
        return await _firebaseAuth.currentUser!.getIdToken();
      } catch (e) {
        _firebaseAuth.signOut();
      }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
