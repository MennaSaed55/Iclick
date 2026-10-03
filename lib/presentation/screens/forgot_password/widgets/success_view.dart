import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../common_widgets/full_size_button_unclicked.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(alpha: 0.15),
          ),
          child: Center(
            child: Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.success,
              size: 42.sp,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Email Sent!',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.cBlack,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'A password reset link has been dispatched to your email address.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.cGrey3,
            height: 1.5,
          ),
        ),
        SizedBox(height: 32.h),
        FullSizeButtonUnClicked(
          onPressed: () => Navigator.pop(context),
          text: 'Back to Sign In',
        ),
      ],
    );

  }
}
