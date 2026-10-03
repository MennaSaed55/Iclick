import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/errors/exceptions.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);
  Future<String> uploadProfileImage({
    required String userId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw const StorageException('Selected image file does not exist.');
      }

      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'uploadedBy': userId},
      );

      final uploadTask = await ref.putFile(file, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw StorageException(e.message ?? 'Failed to upload profile image.');
    } catch (e) {
      throw StorageException('Unexpected storage error: ${e.toString()}');
    }
  }

  Future<String> uploadPostImage({
    required String postId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      final ref = _storage.ref().child('post_images').child('$postId.jpg');
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      final uploadTask = await ref.putFile(file, metadata);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw StorageException(e.message ?? 'Failed to upload post image.');
    } catch (e) {
      throw StorageException('Failed to upload post image: ${e.toString()}');
    }
  }
}
