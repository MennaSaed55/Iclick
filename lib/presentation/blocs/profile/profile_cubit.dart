import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../../domain/usecases/profile/get_device_info_use_case.dart';
import '../../../domain/usecases/profile/update_profile_use_case.dart';
import '../../../domain/usecases/profile/upload_profile_image_use_case.dart';
import '../../../services/biometric_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCurrentUserUseCase getCurrentUser;
  final UpdateProfileUseCase updateProfile;
  final UploadProfileImageUseCase uploadProfileImage;
  final GetDeviceInfoUseCase getDeviceInfo;
  final BiometricService biometricService;
  final ImagePicker _imagePicker;

  ProfileCubit({
    required this.getCurrentUser,
    required this.updateProfile,
    required this.uploadProfileImage,
    required this.getDeviceInfo,
    required this.biometricService,
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       super(const ProfileInitial());

  Future<bool> authenticateWithBiometrics() async {
    final available = await biometricService.isAvailable();
    if (!available) {
      // If hardware unavailable on device/simulator, permit entry gracefully
      return true;
    }

    final success = await biometricService.authenticate(
      reason: 'Authenticate to access your ConnectMe profile',
    );

    if (success) {
      emit(const BiometricAuthSuccess());
      return true;
    } else {
      emit(const BiometricAuthFailed(AppStrings.errorBiometricCancelled));
      return false;
    }
  }

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final userResult = await getCurrentUser.call();
    DeviceInfoEntity? deviceInfo;

    final deviceResult = await getDeviceInfo.call();
    deviceResult.fold(
      (failure) => deviceInfo = null,
      (info) => deviceInfo = info,
    );

    userResult.fold((failure) => emit(ProfileError(failure.message)), (user) {
      if (user != null) {
        emit(ProfileLoaded(user: user, deviceInfo: deviceInfo));
      } else {
        emit(const ProfileError('User session expired. Please sign in again.'));
      }
    });
  }

  Future<void> pickAndUploadImage({
    required String userId,
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;

      final previousState = state;
      emit(const ProfileImageUploading());

      final uploadResult = await uploadProfileImage.call(
        UploadProfileImageParams(userId: userId, imagePath: picked.path),
      );

      uploadResult.fold(
        (failure) {
          emit(ProfileError(failure.message));
          if (previousState is ProfileLoaded) {
            emit(previousState);
          }
        },
        (downloadUrl) {
          if (previousState is ProfileLoaded) {
            final updatedUser = previousState.user.copyWith(
              profileImageUrl: downloadUrl,
            );
            emit(previousState.copyWith(user: updatedUser));
          } else {
            loadProfile();
          }
        },
      );
    } catch (e) {
      emit(ProfileError('Failed to pick or upload image: $e'));
    }
  }

  Future<void> saveProfile({
    required String userId,
    String? fullName,
    String? bio,
    String? location,
  }) async {
    emit(const ProfileUpdating());

    final result = await updateProfile.call(
      UpdateProfileParams(
        userId: userId,
        fullName: fullName,
        bio: bio,
        location: location,
      ),
    );

    result.fold((failure) => emit(ProfileError(failure.message)), (
      updatedUser,
    ) {
      loadProfile();
    });
  }
}
