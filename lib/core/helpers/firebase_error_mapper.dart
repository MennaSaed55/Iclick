import 'package:firebase_auth/firebase_auth.dart';
import '../errors/failures.dart';

/// Maps [FirebaseAuthException] error codes to user-readable [AuthFailure] messages.
///
/// This is the single point where Firebase error codes are translated.
/// No raw Firebase error messages ever reach the UI layer.
class FirebaseErrorMapper {
  FirebaseErrorMapper._();

  /// Maps a [FirebaseAuthException] to a domain [AuthFailure].
  static AuthFailure fromAuthException(FirebaseAuthException e) {
    final message = switch (e.code) {
      'invalid-email' => 'Please enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect email or password.',
      'email-already-in-use' => 'An account already exists for this email.',
      'operation-not-allowed' =>
        'Email/password sign-in is not enabled. Contact support.',
      'weak-password' => 'Password must be at least 6 characters.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'network-request-failed' =>
        'Network error. Check your internet connection.',
      'requires-recent-login' =>
        'Please sign in again to complete this action.',
      'invalid-credential' => 'Incorrect email or password.',
      'account-exists-with-different-credential' =>
        'An account already exists with this email using a different sign-in method.',
      'credential-already-in-use' =>
        'This credential is already linked to another account.',
      'expired-action-code' =>
        'This action link has expired. Please request a new one.',
      'invalid-action-code' =>
        'This action link is invalid. Please request a new one.',
      _ => 'Authentication failed. Please try again.',
    };

    return AuthFailure(message);
  }

  /// Maps a generic [FirebaseException] to a [ServerFailure].
  static ServerFailure fromFirebaseException(FirebaseException e) {
    final message = switch (e.code) {
      'permission-denied' =>
        'You do not have permission to perform this action.',
      'unavailable' => 'Service temporarily unavailable. Please try again.',
      'deadline-exceeded' => 'Request timed out. Please try again.',
      'not-found' => 'The requested resource was not found.',
      'already-exists' => 'This resource already exists.',
      'resource-exhausted' => 'Service quota exceeded. Please try again later.',
      _ => 'Server error. Please try again.',
    };

    return ServerFailure(message);
  }
}
