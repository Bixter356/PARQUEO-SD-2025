import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = GoogleSignIn();
  GoogleSignInAccount? gUser;
  Future<User?> signInWithGoogle() async {
    try {
      // Iniciar sesión con Google
      gUser = await _signIn.signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      // Obtener el usuario autenticado
      final User? user = authResult.user;
      
      return user;
    } catch (e) {
      log('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      _signIn.signOut();
      _auth.signOut();

    } catch (e) {
      log('Error al iniciar sesión con Google: $e');
      
    }
  }
  Future<String?> getUID() async {
    try {
      return _auth.currentUser!.uid;
    } catch (e) {
      log('Error al iniciar sesión con Google: $e');
      return null;
    }
  }
}
