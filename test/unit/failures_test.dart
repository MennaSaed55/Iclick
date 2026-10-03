import 'package:flutter_test/flutter_test.dart';
import 'package:iclick/core/errors/failures.dart';

void main() {
  group('Domain Failures Hierarchy Tests', () {
    test('AuthFailure has correct error message and equality', () {
      const f1 = AuthFailure('Incorrect email or password.');
      const f2 = AuthFailure('Incorrect email or password.');
      const f3 = AuthFailure('Account disabled.');

      expect(f1.message, 'Incorrect email or password.');
      expect(f1, equals(f2));
      expect(f1, isNot(equals(f3)));
    });

    test('ServerFailure and DeviceFailure are distinct Failure subtypes', () {
      const serverFail = ServerFailure('Service temporarily unavailable.');
      const deviceFail = DeviceFailure('Biometrics not available.');

      expect(serverFail, isA<Failure>());
      expect(deviceFail, isA<Failure>());
      expect(serverFail, isNot(equals(deviceFail)));
    });
  });
}
