import 'package:cloud_firestore/cloud_firestore.dart';

/// Singleton Firestore service used across all repositories.
///
/// Singleton Pattern:
/// Provides one shared FirestoreService instance throughout the application lifecycle.
class FirestoreService {
  static FirestoreService? _instance;
  final FirebaseFirestore _firestore;

  /// Private internal constructor preventing external instantiation.
  FirestoreService._internal(this._firestore);

  /// Factory constructor returning the single shared application-wide instance.
  factory FirestoreService([FirebaseFirestore? firestore]) {
    _instance ??= FirestoreService._internal(
      firestore ?? FirebaseFirestore.instance,
    );
    return _instance!;
  }

  // ---------------------------------------------------------------------------
  // Users Collection
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  Future<void> setUser(String uid, Map<String, dynamic> data) {
    return usersCollection.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return usersCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) {
    return usersCollection.doc(uid).snapshots();
  }

  // ---------------------------------------------------------------------------
  // Posts Collection
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get postsCollection =>
      _firestore.collection('posts');

  Future<void> createPost(String postId, Map<String, dynamic> data) {
    return postsCollection.doc(postId).set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPost(String postId) {
    return postsCollection.doc(postId).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream() {
    return postsCollection.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) {
    return postsCollection.doc(postId).update(data);
  }

  // ---------------------------------------------------------------------------
  // Activity Collection
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get activityCollection =>
      _firestore.collection('activity');

  Stream<QuerySnapshot<Map<String, dynamic>>> activityStream(String userId) {
    return activityCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ---------------------------------------------------------------------------
  // Generic helpers
  // ---------------------------------------------------------------------------

  WriteBatch batch() => _firestore.batch();

  Future<void> runTransaction(
    Future<void> Function(Transaction transaction) updateFunction,
  ) {
    return _firestore.runTransaction(updateFunction);
  }
}
