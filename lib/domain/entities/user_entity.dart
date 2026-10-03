import 'package:equatable/equatable.dart';
class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final String? location;
  final String? deviceModel;
  final String? osVersion;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.location,
    this.deviceModel,
    this.osVersion,
    this.createdAt,
  });

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    String? bio,
    String? location,
    String? deviceModel,
    String? osVersion,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    profileImageUrl,
    bio,
    location,
    deviceModel,
    osVersion,
    createdAt,
  ];
}
