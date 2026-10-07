import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/member_location.dart';

/// Helper factory for generating Google Map [Marker] instances for community members.
class MemberMarkerFactory {
  MemberMarkerFactory._();

  /// Creates a [Marker] from a [MemberLocation] entity.
  static Marker create(MemberLocation member) {
    return Marker(
      markerId: MarkerId(member.id),
      position: LatLng(member.latitude, member.longitude),
      infoWindow: InfoWindow(
        title: member.name,
        snippet: '${member.role} • ${member.city}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );
  }
}
