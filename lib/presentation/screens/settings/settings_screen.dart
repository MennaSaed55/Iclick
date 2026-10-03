import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cWhite,
        elevation: 0,
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
          'Settings',
          style: GoogleFonts.inter(
            color: AppColors.cBlack,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile Information',
            onTap: () => Navigator.pop(context),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Password reset link sent to your registered email.',
                  ),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Access',
            subtitle: 'Secure profile behind fingerprint/face authentication',
            trailing: Switch(
              value: true,
              activeTrackColor: AppColors.cDarkPurple,
              onChanged: (val) {},
            ),
          ),
          SizedBox(height: 20.h),
          _buildSectionHeader('Community & Privacy'),
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: 'Push Notifications',
            trailing: Switch(
              value: true,
              activeTrackColor: AppColors.cDarkPurple,
              onChanged: (val) {},
            ),
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Terms of Service & Privacy',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            title: 'About ConnectMe',
            subtitle: 'Version 1.0.0 (Release Build)',
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.cRed, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Sign Out of ConnectMe',
                  style: TextStyle(
                    color: AppColors.cRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.cGrey3,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.cWhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.cDarkPurple),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.cBlack,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: AppColors.cGrey3, fontSize: 12.sp),
              )
            : null,
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.cGrey4,
                  )
                : null),
        onTap: onTap,
      ),
    );
  }
}
