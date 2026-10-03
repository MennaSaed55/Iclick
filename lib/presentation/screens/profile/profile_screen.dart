import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showImagePickerModal(BuildContext context, String userId) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.cGrey5,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Change Profile Photo',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cBlack,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cPurple.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.cDarkPurple,
                  ),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.read<ProfileCubit>().pickAndUploadImage(
                    userId: userId,
                    source: ImageSource.gallery,
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.cRed,
                  ),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.read<ProfileCubit>().pickAndUploadImage(
                    userId: userId,
                    source: ImageSource.camera,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            backgroundColor: AppColors.cWhite,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.cDarkPurple),
            ),
          );
        }

        if (state is ProfileLoaded) {
          final user = state.user;
          final deviceInfo = state.deviceInfo;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.cWhite,
              elevation: 0,
              centerTitle: true,
              title: Text(
                user.fullName.isNotEmpty ? user.fullName : 'Profile',
                style: GoogleFonts.inter(
                  color: AppColors.cBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.sp,
                ),
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/setting.svg',
                    width: 22.w,
                    height: 22.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.cBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.editProfile.path);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // --- Header with Avatar & Stats ---
                  Container(
                    color: AppColors.cWhite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar with Camera Badge
                            GestureDetector(
                              onTap: () =>
                                  _showImagePickerModal(context, user.id),
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.primaryGradient,
                                    ),
                                    child: CircleAvatar(
                                      radius: 40.r,
                                      backgroundColor: AppColors.cGrey6,
                                      backgroundImage:
                                          user.profileImageUrl != null
                                          ? CachedNetworkImageProvider(
                                              user.profileImageUrl!,
                                            )
                                          : null,
                                      child: user.profileImageUrl == null
                                          ? Text(
                                              user.fullName.isNotEmpty
                                                  ? user.fullName[0]
                                                        .toUpperCase()
                                                  : 'U',
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.cDarkPurple,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.cDarkPurple,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.cWhite,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 14.sp,
                                        color: AppColors.cWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 24.w),

                            // Stats: Posts, Followers, Following
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('Posts', '12'),
                                  _buildStatItem('Followers', '3.4k'),
                                  _buildStatItem('Following', '428'),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Name, Bio, Location
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.cBlack,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.cGrey3,
                                ),
                              ),
                              if (user.bio != null && user.bio!.isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  user.bio!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.cBlack,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                              if (user.location != null &&
                                  user.location!.isNotEmpty) ...[
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/globe.svg',
                                      width: 14.w,
                                      height: 14.h,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.cBlue,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      user.location!,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.cBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Action Buttons: Edit Profile & Share
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.editProfile.path,
                                    arguments: user,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.cGrey5,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                ),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: AppColors.cBlack,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.cGrey5,
                                  width: 1.2,
                                ),
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/export.svg',
                                  width: 18.w,
                                  height: 18.h,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.cBlack,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // --- Device Information Card (Phase 3 Requirement) ---
                  if (deviceInfo != null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.cWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cGrey6),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.cDarkPurple.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.phone_android_rounded,
                              color: AppColors.cDarkPurple,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Device Info',
                                  style: TextStyle(
                                    color: AppColors.cBlack,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  '${deviceInfo.manufacturer} ${deviceInfo.model} • ${deviceInfo.osVersion}',
                                  style: TextStyle(
                                    color: AppColors.cGrey3,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.verified_user_outlined,
                            color: AppColors.success,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 12.h),

                  // --- Tab Bar (Grid Posts / Tagged) ---
                  Container(
                    color: AppColors.cWhite,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.cDarkPurple,
                      labelColor: AppColors.cDarkPurple,
                      unselectedLabelColor: AppColors.cGrey3,
                      tabs: const [
                        Tab(icon: Icon(Icons.grid_on_rounded)),
                        Tab(icon: Icon(Icons.bookmark_border_rounded)),
                      ],
                    ),
                  ),

                  // --- Posts Grid ---
                  Container(
                    color: AppColors.cWhite,
                    height: 360.h,
                    child: TabBarView(
                      controller: _tabController,
                      children: [_buildPostsGrid(), _buildSavedGrid()],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Unable to load profile.')),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.cBlack,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.cGrey3),
        ),
      ],
    );
  }

  Widget _buildPostsGrid() {
    final images = [
      'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=400',
      'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400',
      'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: AppColors.cGrey6),
          errorWidget: (context, url, error) => Container(
            color: AppColors.cGrey6,
            child: const Icon(Icons.image, color: AppColors.cGrey4),
          ),
        );
      },
    );
  }

  Widget _buildSavedGrid() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border, size: 48.sp, color: AppColors.cGrey4),
          SizedBox(height: 8.h),
          Text(
            'No saved posts yet',
            style: TextStyle(color: AppColors.cGrey3, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
