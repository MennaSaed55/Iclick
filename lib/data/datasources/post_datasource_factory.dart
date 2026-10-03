import 'firestore_post_datasource.dart';
import 'local_post_datasource.dart';
import 'post_data_source.dart';

enum PostDataSourceType { firestore, local }
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
