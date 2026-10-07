import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.profileImageUrl,
    super.bio,
    super.location,
    super.deviceModel,
    super.osVersion,
    super.createdAt,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      fullName: user.displayName ?? '',
      email: user.email ?? '',
      profileImageUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      profileImageUrl: data['profileImageUrl'] as String?,
      bio: data['bio'] as String?,
      location: data['location'] as String?,
      deviceModel: data['deviceModel'] as String?,
      osVersion: data['osVersion'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      deviceModel: json['deviceModel'] as String?,
      osVersion: json['osVersion'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (bio != null) 'bio': bio,
      if (location != null) 'location': location,
      if (deviceModel != null) 'deviceModel': deviceModel,
      if (osVersion != null) 'osVersion': osVersion,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      profileImageUrl: entity.profileImageUrl,
      bio: entity.bio,
      location: entity.location,
      deviceModel: entity.deviceModel,
      osVersion: entity.osVersion,
      createdAt: entity.createdAt,
    );
  }
}

/// **Design Pattern: Builder Pattern**
///
/// **Where**: Applied in [UserBuilder] for constructing [UserModel] instances.
/// **Why**: Provides step-by-step construction of complex user profiles. Allows setting
/// only essential credentials (id, fullName, email) during sign-up, while incrementally
/// populating optional fields (bio, profileImageUrl, deviceModel, osVersion) during
/// later lifecycle events without requiring massive parameter lists.
class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _profileImageUrl;
  String? _bio;
  String? _location;
  String? _deviceModel;
  String? _osVersion;
  DateTime? _createdAt;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setProfileImageUrl(String? url) {
    _profileImageUrl = url;
    return this;
  }

  UserBuilder setBio(String? bio) {
    _bio = bio;
    return this;
  }

  UserBuilder setLocation(String? location) {
    _location = location;
    return this;
  }

  UserBuilder setDeviceModel(String? model) {
    _deviceModel = model;
    return this;
  }

  UserBuilder setOsVersion(String? version) {
    _osVersion = version;
    return this;
  }

  UserBuilder setCreatedAt(DateTime? createdAt) {
    _createdAt = createdAt;
    return this;
  }

  UserModel build() {
    assert(_id != null, 'UserBuilder: id is required');
    assert(_fullName != null, 'UserBuilder: fullName is required');
    assert(_email != null, 'UserBuilder: email is required');

    return UserModel(
      id: _id!,
      fullName: _fullName!,
      email: _email!,
      profileImageUrl: _profileImageUrl,
      bio: _bio,
      location: _location,
      deviceModel: _deviceModel,
      osVersion: _osVersion,
      createdAt: _createdAt,
    );
  }
}
