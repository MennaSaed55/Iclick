import 'package:flutter_test/flutter_test.dart';
import 'package:iclick/data/models/user_model.dart';
import 'package:iclick/domain/entities/user_entity.dart';

void main() {
  group('UserModel & UserBuilder Tests', () {
    test('UserBuilder builds UserModel with required fields', () {
      final user = UserBuilder()
          .setId('uid_123')
          .setFullName('Elena Rostova')
          .setEmail('elena@connectme.app')
          .build();

      expect(user.id, 'uid_123');
      expect(user.fullName, 'Elena Rostova');
      expect(user.email, 'elena@connectme.app');
      expect(user.bio, isNull);
      expect(user.profileImageUrl, isNull);
    });

    test('UserBuilder assigns optional fields correctly', () {
      final user = UserBuilder()
          .setId('uid_456')
          .setFullName('Marcus Vance')
          .setEmail('marcus@connectme.app')
          .setBio('UI/UX Designer')
          .setLocation('Downtown Arts')
          .setDeviceModel('Pixel 8')
          .setOsVersion('Android 14')
          .setProfileImageUrl('https://example.com/avatar.jpg')
          .build();

      expect(user.id, 'uid_456');
      expect(user.bio, 'UI/UX Designer');
      expect(user.location, 'Downtown Arts');
      expect(user.deviceModel, 'Pixel 8');
      expect(user.osVersion, 'Android 14');
      expect(user.profileImageUrl, 'https://example.com/avatar.jpg');
    });

    test('UserBuilder throws AssertionError when required fields missing', () {
      expect(() => UserBuilder().build(), throwsA(isA<AssertionError>()));
    });

    test('UserModel fromJson & toJson round trip consistency', () {
      final jsonMap = {
        'id': 'uid_789',
        'fullName': 'Sophia Chen',
        'email': 'sophia@connectme.app',
        'bio': 'Community lead',
        'location': 'Creative Park',
        'deviceModel': 'iPhone 15',
        'osVersion': 'iOS 17',
      };

      final user = UserModel.fromJson(jsonMap);
      expect(user.id, 'uid_789');
      expect(user.fullName, 'Sophia Chen');
      expect(user.email, 'sophia@connectme.app');

      final serialized = user.toJson();
      expect(serialized['id'], 'uid_789');
      expect(serialized['fullName'], 'Sophia Chen');
      expect(serialized['email'], 'sophia@connectme.app');
    });

    test('UserModel is an instance of UserEntity (Clean Architecture)', () {
      final user = UserModel(
        id: '1',
        fullName: 'Test User',
        email: 'test@example.com',
      );
      expect(user, isA<UserEntity>());
    });
  });
}
