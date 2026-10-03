import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../core/helpers/firebase_error_mapper.dart';
import '../models/user_model.dart';
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'null-user',
          message: 'Sign-in succeeded but no user was returned.',
        );
      }
      // Attempt to load the Firestore profile; fall back to Firebase Auth user.
      return await _fetchUserProfile(user.uid) ??
          UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Sign-in failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'null-user',
          message: 'Registration succeeded but no user was returned.',
        );
      }
      await user.updateDisplayName(fullName.trim());

      // Builder Pattern:
      // Constructs UserModel step by step with only the fields known during registration.
      final userModel = UserBuilder()
          .setId(user.uid)
          .setFullName(fullName.trim())
          .setEmail(email.trim())
          .setCreatedAt(DateTime.now())
          .build();

      await _saveUserProfile(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        code: 'unknown',
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorMapper.fromAuthException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return await _fetchUserProfile(user.uid) ??
        UserModel.fromFirebaseUser(user);
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await _fetchUserProfile(user.uid) ??
          UserModel.fromFirebaseUser(user);
    });
  }
Future<UserModel?> _fetchUserProfile(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc);
    } catch (_) {
      // Firestore fetch failure is non-fatal — fall back to Auth user.
      return null;
    }
  }

  Future<void> _saveUserProfile(UserModel model) async {
    try {
      await firestore
          .collection('users')
          .doc(model.id)
          .set(model.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to save user profile: $e');
    }
  }
}
