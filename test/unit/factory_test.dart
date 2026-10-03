import 'package:flutter_test/flutter_test.dart';
import 'package:iclick/data/datasources/firestore_post_datasource.dart';
import 'package:iclick/data/datasources/local_post_datasource.dart';
import 'package:iclick/data/datasources/post_data_source.dart';
import 'package:iclick/data/datasources/post_datasource_factory.dart';
import 'package:iclick/data/models/post_model.dart';

class FakeFirestorePostDataSource implements FirestorePostDataSource {
  @override
  Future<PostModel> createPost(PostModel post) async => post;

  @override
  Future<List<PostModel>> getPosts() async => [];

  @override
  Future<void> updateLikes(String postId, List<String> likes) async {}

  @override
  Stream<List<PostModel>> watchPosts() async* {
    yield [];
  }
}

void main() {
  late FakeFirestorePostDataSource fakeFirestoreSource;
  late LocalPostDataSource localSource;
  late PostDataSourceFactory factory;

  setUp(() {
    fakeFirestoreSource = FakeFirestorePostDataSource();
    localSource = LocalPostDataSource();
    factory = PostDataSourceFactory(
      firestoreDataSource: fakeFirestoreSource,
      localDataSource: localSource,
    );
  });

  group('Factory Pattern — PostDataSourceFactory Tests', () {
    test('Returns FirestorePostDataSource when type is firestore', () {
      final source = factory.createDataSource(
        type: PostDataSourceType.firestore,
      );
      expect(source, isA<FirestorePostDataSource>());
      expect(source, isA<PostDataSource>());
    });

    test('Returns LocalPostDataSource when type is local', () {
      final source = factory.createDataSource(type: PostDataSourceType.local);
      expect(source, isA<LocalPostDataSource>());
      expect(source, isA<PostDataSource>());
    });

    test(
      'LocalPostDataSource provides initial seed posts without crashing',
      () async {
        final source = factory.createDataSource(type: PostDataSourceType.local);
        final posts = await source.getPosts();
        expect(posts, isNotEmpty);
        expect(posts.first.authorName, isNotEmpty);
      },
    );
  });
}
