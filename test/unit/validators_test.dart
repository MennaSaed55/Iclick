import 'package:flutter_test/flutter_test.dart';
import 'package:iclick/core/extensions/string_extensions.dart';

void main() {
  group('Validators and String Extensions Test', () {
    test('Email validation returns null for valid emails', () {
      expect(Validators.email('test@connectme.app'), isNull);
      expect(Validators.email('alex.smith+dev@domain.co'), isNull);
    });

    test('Email validation returns error for invalid or empty emails', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email('user@domain'), isNotNull);
    });

    test('Password validation requires at least 6 characters', () {
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('securePassword123'), isNull);
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('Full Name validation requires first letter capitalized', () {
      expect(Validators.fullName('John Doe'), isNull);
      expect(Validators.fullName('Alex'), isNull);
      expect(Validators.fullName('john'), isNotNull);
      expect(Validators.fullName(''), isNotNull);
      expect(Validators.fullName(null), isNotNull);
    });

    test('Confirm password validator verifies match', () {
      final confirm = Validators.confirmPassword('password123');
      expect(confirm('password123'), isNull);
      expect(confirm('different'), isNotNull);
      expect(confirm(''), isNotNull);
    });
  });
}
