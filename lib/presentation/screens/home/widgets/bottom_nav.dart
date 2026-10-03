import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_router/app_router.dart';
import '../../../../core/constants/app_colors.dart';

class BottomNav extends StatefulWidget {
   late final int currentNavIndex;
   final VoidCallback onProfileNavTap;
    BottomNav({super.key, required this.currentNavIndex, required this.onProfileNavTap});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: AppColors.cWhite,
      elevation: 12,
      child: SizedBox(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            IconButton(
              icon: SvgPicture.asset(
                'assets/nav_bar/home.svg',
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  widget.currentNavIndex == 0
                      ? AppColors.cDarkPurple
                      : AppColors.cGrey4,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => setState(() =>  widget.currentNavIndex = 0),
            ),

            // Explore / Map
            IconButton(
              icon: SvgPicture.asset(
                'assets/nav_bar/category.svg',
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  widget.currentNavIndex == 1
                      ? AppColors.cDarkPurple
                      : AppColors.cGrey4,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.map.path);
              },
            ),

            const SizedBox(width: 48),
            IconButton(
              icon: SvgPicture.asset(
                'assets/nav_bar/message.svg',
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  widget.currentNavIndex == 2
                      ? AppColors.cDarkPurple
                      : AppColors.cGrey4,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                setState(() =>  widget.currentNavIndex = 2);
              },
            ),

            IconButton(
              icon: SvgPicture.asset(
                'assets/nav_bar/profile.svg',
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  widget.currentNavIndex == 3
                      ? AppColors.cDarkPurple
                      : AppColors.cGrey4,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: widget.onProfileNavTap,
            ),
          ],
        ),
      ),
    );
  }
}
