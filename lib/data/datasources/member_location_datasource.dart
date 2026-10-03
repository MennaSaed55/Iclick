import '../../domain/entities/member_location.dart';

/// Provides community member locations across distinct global cities.
abstract class MemberLocationDataSource {
  List<MemberLocation> getMemberLocations();
}

class MemberLocationDataSourceImpl implements MemberLocationDataSource {
  const MemberLocationDataSourceImpl();

  @override
  List<MemberLocation> getMemberLocations() {
    return const [
      MemberLocation(
        id: 'member_sf',
        name: 'Elena Rostova',
        city: 'San Francisco, USA',
        role: 'Creative Director',
        latitude: 37.7749,
        longitude: -122.4194,
      ),
      MemberLocation(
        id: 'member_nyc',
        name: 'Marcus Vance',
        city: 'New York, USA',
        role: 'UI/UX Designer',
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      MemberLocation(
        id: 'member_london',
        name: 'Sophia Chen',
        city: 'London, UK',
        role: 'Product Lead',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
      MemberLocation(
        id: 'member_cairo',
        name: 'Omar Farooq',
        city: 'Cairo, Egypt',
        role: 'Mobile Architect',
        latitude: 30.0444,
        longitude: 31.2357,
      ),
      MemberLocation(
        id: 'member_tokyo',
        name: 'Kenji Sato',
        city: 'Tokyo, Japan',
        role: 'Community Lead',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
    ];
  }
}
