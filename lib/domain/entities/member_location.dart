import 'package:equatable/equatable.dart';

/// Pure domain entity representing a community member's geographical presence.
class MemberLocation extends Equatable {
  final String id;
  final String name;
  final String city;
  final String role;
  final double latitude;
  final double longitude;

  const MemberLocation({
    required this.id,
    required this.name,
    required this.city,
    required this.role,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, name, city, role, latitude, longitude];
}
