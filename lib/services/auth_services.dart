import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthServices {
  AuthServices._pc();
  static final AuthServices instance = AuthServices._pc();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> anonymousLogin() async {
    UserCredential credential = await auth.signInAnonymously();
    return credential.user;
  }

  Future<User?> signUp({required String email, required String psw}) async {
    User? user;
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: psw);

      user = credential.user;
    } catch (e) {
      Logger().e('Execption : ${e.toString()}');
    }
    return user;
  }

  Future<User?> signIn({required String email, required String psw}) async {
    User? user;
    try {
      UserCredential credential =
          await auth.signInWithEmailAndPassword(email: email, password: psw);
      user = credential.user;
    } catch (e) {
      Logger().e('Exception : ${e.toString()}');
    }
    return user;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return await auth.signInWithCredential(credential);
  }

  Future<void> logOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }
}
