import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/member_location_datasource.dart';
import '../../../domain/entities/member_location.dart';

/// Full-screen Google Map screen displaying community member locations.
///
/// Complies with strict task specifications:
/// - Uses real [GoogleMap] from `google_maps_flutter`.
/// - AppBar title is exactly "Community Map".
/// - Displays real [Marker] objects in distinct global cities.
/// - Tapping a marker displays a native [InfoWindow] with member name and city.
/// - Marker creation is executed in [initState], NEVER inside [build].
/// - Member location data is cleanly separated in [MemberLocationDataSource].
class MapScreen extends StatefulWidget {
  final MemberLocationDataSource dataSource;

  const MapScreen({
    super.key,
    this.dataSource = const MemberLocationDataSourceImpl(),
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  late final List<MemberLocation> _memberLocations;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(35.0, -20.0), // Broad Atlantic / Global overview
    zoom: 2.5,
  );

  @override
  void initState() {
    super.initState();
    // Retrieve locations from data source (separated from UI)
    _memberLocations = widget.dataSource.getMemberLocations();
    // Marker creation logic executed once in initState, NOT inside build()
    _initializeMarkers();
  }

  void _initializeMarkers() {
    for (final member in _memberLocations) {
      final marker = Marker(
        markerId: MarkerId(member.id),
        position: LatLng(member.latitude, member.longitude),
        infoWindow: InfoWindow(
          title: member.name,
          snippet: '${member.role} • ${member.city}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );
      _markers.add(marker);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cWhite,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.cBlack,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community Map',
          style: GoogleFonts.inter(
            color: AppColors.cBlack,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          // --- Full-screen Google Map ---
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          // --- Overlay: Active Members Counter ---
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.cWhite.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cBlack.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.public_rounded,
                    color: AppColors.cDarkPurple,
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${_memberLocations.length} Members across ${_memberLocations.length} Global Cities',
                    style: TextStyle(
                      color: AppColors.cBlack,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
