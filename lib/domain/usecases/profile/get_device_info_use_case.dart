import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/either.dart';
import '../../../services/device_info_service.dart';
import '../usecase.dart';

class DeviceInfoEntity extends Equatable {
  final String model;
  final String osVersion;
  final String manufacturer;

  const DeviceInfoEntity({
    required this.model,
    required this.osVersion,
    required this.manufacturer,
  });

  @override
  List<Object?> get props => [model, osVersion, manufacturer];
}

class GetDeviceInfoUseCase extends UseCaseNoParams<DeviceInfoEntity> {
  final DeviceInfoService _service;

  GetDeviceInfoUseCase(this._service);

  @override
  Future<Either<Failure, DeviceInfoEntity>> call() async {
    try {
      final info = await _service.getDeviceInfo();
      return right(
        DeviceInfoEntity(
          model: info.model,
          osVersion: info.osVersion,
          manufacturer: info.manufacturer,
        ),
      );
    } catch (e) {
      return left(DeviceFailure('Failed to retrieve device information: $e'));
    }
  }
}
