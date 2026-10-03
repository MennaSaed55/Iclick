import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
class BiometricService {
  final LocalAuthentication _auth;

  BiometricService([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
 Future<bool> authenticate({
    String reason = 'Authenticate to access your profile',
  }) async {
    try {
      final available = await isAvailable();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
