import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/firestore_post_datasource.dart';
import 'data/datasources/local_post_datasource.dart';
import 'data/datasources/post_datasource_factory.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/auth/get_current_user_use_case.dart';
import 'domain/usecases/auth/reset_password_use_case.dart';
import 'domain/usecases/auth/sign_in_use_case.dart';
import 'domain/usecases/auth/sign_out_use_case.dart';
import 'domain/usecases/auth/sign_up_use_case.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/get_posts.dart';
import 'domain/usecases/profile/get_device_info_use_case.dart';
import 'domain/usecases/profile/update_profile_use_case.dart';
import 'domain/usecases/profile/upload_profile_image_use_case.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/post/post_cubit.dart';
import 'presentation/blocs/profile/profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/device_info_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
   sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  sl.registerLazySingleton<AuthService>(() => AuthService(sl<FirebaseAuth>()));

  sl.registerLazySingleton<FirestoreService>(
  () => FirestoreService(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<StorageService>(
    () => StorageService(sl<FirebaseStorage>()),
  );

  sl.registerLazySingleton<BiometricService>(() => BiometricService());

  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<FirestoreService>()),
  );

  sl.registerLazySingleton<FirestorePostDataSource>(
    () => FirestorePostDataSource(sl<FirestoreService>()),
  );

  sl.registerLazySingleton<LocalPostDataSource>(() => LocalPostDataSource());

  sl.registerLazySingleton<PostDataSourceFactory>(
    () => PostDataSourceFactory(
      firestoreDataSource: sl<FirestorePostDataSource>(),
      localDataSource: sl<LocalPostDataSource>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      userDataSource: sl<UserRemoteDataSource>(),
      storageService: sl<StorageService>(),
    ),
  );

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(sl<PostDataSourceFactory>()),
  );

  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UploadProfileImageUseCase>(
    () => UploadProfileImageUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<GetDeviceInfoUseCase>(
    () => GetDeviceInfoUseCase(sl<DeviceInfoService>()),
  );

  sl.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(sl<PostRepository>()),
  );
  sl.registerLazySingleton<CreatePostUseCase>(
    () => CreatePostUseCase(sl<PostRepository>()),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      signInUseCase: sl<SignInUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getCurrentUser: sl<GetCurrentUserUseCase>(),
      updateProfile: sl<UpdateProfileUseCase>(),
      uploadProfileImage: sl<UploadProfileImageUseCase>(),
      getDeviceInfo: sl<GetDeviceInfoUseCase>(),
      biometricService: sl<BiometricService>(),
    ),
  );

  sl.registerFactory<PostCubit>(
    () => PostCubit(
      getPostsUseCase: sl<GetPostsUseCase>(),
      createPostUseCase: sl<CreatePostUseCase>(),
      postRepository: sl<PostRepository>(),
    ),
  );
}
