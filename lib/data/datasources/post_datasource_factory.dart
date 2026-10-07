import 'firestore_post_datasource.dart';
import 'local_post_datasource.dart';
import 'post_data_source.dart';

enum PostDataSourceType { firestore, local }

/// **Design Pattern: Factory Pattern**
///
/// **Where**: Applied in data source creation for post operations.
/// **Why**: Decouples the repository implementation from the specific data source
/// creation logic. Allows the application to switch dynamically between the remote
/// Cloud Firestore datasource and an offline local cache / seed datasource without
/// modifying consumer repositories or use cases.
class PostDataSourceFactory {
  final FirestorePostDataSource firestoreDataSource;
  final LocalPostDataSource localDataSource;

  PostDataSourceFactory({
    required this.firestoreDataSource,
    required this.localDataSource,
  });

  PostDataSource createDataSource({
    PostDataSourceType type = PostDataSourceType.firestore,
  }) {
    switch (type) {
      case PostDataSourceType.firestore:
        return firestoreDataSource;
      case PostDataSourceType.local:
        return localDataSource;
    }
  }
}
