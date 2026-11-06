import 'package:firebase_auth/firebase_auth.dart';

class AuthFailure implements Exception {
  final String code;
  final String message;
  AuthFailure(this.code, this.message);
  @override
  String toString() => message;
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Stream<User?> get userChanges => _auth.userChanges(); // оновлюється після зміни імені/фото

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) =>
      _guard(() async {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
        if (displayName != null && displayName.trim().isNotEmpty) {
          await cred.user!.updateDisplayName(displayName.trim());
        }
      });

  Future<void> signIn({required String email, required String password}) =>
      _guard(() => _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password));

  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> signOut() => _auth.signOut();

  Future<void> updateDisplayName(String name) =>
      _guard(() => _auth.currentUser!.updateDisplayName(name.trim()));

  Future<void> updatePhotoUrl(String url) =>
      _guard(() => _auth.currentUser!.updatePhotoURL(url.trim()));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _guard(() async {
        final user = _auth.currentUser!;
        final cred = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
      });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(e.code, _message(e.code));
    }
  }

  String _message(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Could not sign in. Check your email and password';
      case 'invalid-email':
        return 'Invalid email format';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'network-request-failed':
        return 'Network problem. Check your connection';
      case 'requires-recent-login':
        return 'Please confirm your identity by signing in again';
      default:
        return 'Something went wrong. Try again';
    }
  }
}