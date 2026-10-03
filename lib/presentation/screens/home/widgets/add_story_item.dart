import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class AddStoryItem extends StatelessWidget {
  const AddStoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.cGrey6,
                child: const Icon(Icons.person, color: AppColors.cGrey4),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.cDarkPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 14,
                    color: AppColors.cWhite,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Your Story',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.cBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
