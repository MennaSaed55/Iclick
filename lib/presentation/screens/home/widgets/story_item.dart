import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

class StoryItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  const StoryItem({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.storyGradient,
            ),
            child: CircleAvatar(
              radius: 26.r,
              backgroundColor: AppColors.cWhite,
              child: CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            name,
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
