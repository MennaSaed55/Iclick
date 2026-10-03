import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/profile/get_device_info_use_case.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final DeviceInfoEntity? deviceInfo;

  const ProfileLoaded({required this.user, this.deviceInfo});

  ProfileLoaded copyWith({UserEntity? user, DeviceInfoEntity? deviceInfo}) {
    return ProfileLoaded(
      user: user ?? this.user,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }

  @override
  List<Object?> get props => [user, deviceInfo];
}

final class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}

final class ProfileImageUploading extends ProfileState {
  const ProfileImageUploading();
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

final class BiometricAuthSuccess extends ProfileState {
  const BiometricAuthSuccess();
}

final class BiometricAuthFailed extends ProfileState {
  final String message;

  const BiometricAuthFailed(this.message);

  @override
  List<Object?> get props => [message];
}
