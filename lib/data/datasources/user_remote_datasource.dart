import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../services/firestore_service.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);
  Future<UserModel> updateUser(String userId, Map<String, dynamic> data);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirestoreService _firestoreService;

  UserRemoteDataSourceImpl(this._firestoreService);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await _firestoreService.getUser(userId);
      if (!doc.exists || doc.data() == null) {
        throw const ServerException('User profile not found in Firestore.');
      }
      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firestore error fetching user.');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to retrieve user profile: $e');
    }
  }

  @override
  Future<UserModel> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestoreService.setUser(userId, data);
      final updated = await _firestoreService.getUser(userId);
      return UserModel.fromFirestore(updated);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Firestore error updating profile.');
    } catch (e) {
      throw ServerException('Failed to update user profile: $e');
    }
  }
}
