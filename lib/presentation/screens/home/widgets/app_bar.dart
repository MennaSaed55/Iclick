import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/constants/app_colors.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? showCreatePostDialog;
  final VoidCallback? confirmSignOut;
  final VoidCallback? onProfileTap;

  const AppBarCustom({
    super.key,
    this.showCreatePostDialog,
    this.confirmSignOut,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cWhite,
      elevation: 0.5,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/camera.svg',
          width: 22.w,
          height: 22.h,
          colorFilter: const ColorFilter.mode(
            AppColors.cBlack,
            BlendMode.srcIn,
          ),
        ),
        onPressed: showCreatePostDialog,
      ),
      centerTitle: true,
      title: Text(
        'ConnectMe',
        style: GoogleFonts.inter(
          color: AppColors.cDarkPurple,
          fontWeight: FontWeight.w800,
          fontSize: 22.sp,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/globe.svg',
            width: 22.w,
            height: 22.h,
            colorFilter: const ColorFilter.mode(
              AppColors.cBlue,
              BlendMode.srcIn,
            ),
          ),
          tooltip: 'Community Map',
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.map.path);
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: AppColors.cDarkPurple),
          tooltip: 'Profile (Biometrics)',
          onPressed: onProfileTap,
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.cGrey2),
          tooltip: 'Sign Out',
          onPressed: confirmSignOut,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
