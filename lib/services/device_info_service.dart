import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoData {
  final String model;
  final String osVersion;
  final String manufacturer;

  const DeviceInfoData({
    required this.model,
    required this.osVersion,
    required this.manufacturer,
  });

  @override
  String toString() => '$manufacturer $model (OS: $osVersion)';
}

class DeviceInfoService {
  final DeviceInfoPlugin _plugin;

  DeviceInfoService([DeviceInfoPlugin? plugin])
    : _plugin = plugin ?? DeviceInfoPlugin();

  Future<DeviceInfoData> getDeviceInfo() async {
    try {
      if (kIsWeb) {
        final web = await _plugin.webBrowserInfo;
        return DeviceInfoData(
          model: web.browserName.name,
          osVersion: web.platform ?? 'Web',
          manufacturer: web.vendor ?? 'Browser',
        );
      } else if (Platform.isAndroid) {
        final android = await _plugin.androidInfo;
        return DeviceInfoData(
          model: android.model,
          osVersion:
              'Android ${android.version.release} (SDK ${android.version.sdkInt})',
          manufacturer: android.manufacturer,
        );
      } else if (Platform.isIOS) {
        final ios = await _plugin.iosInfo;
        return DeviceInfoData(
          model: ios.utsname.machine,
          osVersion: 'iOS ${ios.systemVersion}',
          manufacturer: 'Apple',
        );
      } else {
        return const DeviceInfoData(
          model: 'Desktop / Other',
          osVersion: 'Unknown',
          manufacturer: 'Generic',
        );
      }
    } catch (_) {
      return const DeviceInfoData(
        model: 'Unknown Device',
        osVersion: 'Unknown OS',
        manufacturer: 'Unknown',
      );
    }
  }
}
