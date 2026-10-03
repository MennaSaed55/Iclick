import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/app_colors.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onProfileTap;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    this.onComment,
    this.onShare,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.isLikedBy(currentUserId);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.cWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cBlack.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Author Header ---
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.cGrey6,
                      backgroundImage: post.authorAvatarUrl != null
                          ? CachedNetworkImageProvider(post.authorAvatarUrl!)
                          : null,
                      child: post.authorAvatarUrl == null
                          ? Text(
                              post.authorName.isNotEmpty
                                  ? post.authorName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color: AppColors.cDarkPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(
                          color: AppColors.cBlack,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          if (post.location != null &&
                              post.location!.isNotEmpty) ...[
                            Text(
                              post.location!,
                              style: TextStyle(
                                color: AppColors.cGrey3,
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              ' • ',
                              style: TextStyle(
                                color: AppColors.cGrey4,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                          Text(
                            timeago.format(post.createdAt),
                            style: TextStyle(
                              color: AppColors.cGrey4,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: AppColors.cGrey3),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          if (post.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              child: Text(
                post.content,
                style: TextStyle(
                  color: AppColors.cBlack,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ),

          SizedBox(height: 8.h),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  width: double.infinity,
                  height: 240.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 240.h,
                    color: AppColors.cGrey6,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180.h,
                    color: AppColors.cGrey6,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: AppColors.cGrey4),
                    ),
                  ),
                ),
              ),
            ),

          // --- Actions Row ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: onLike,
                  icon: SvgPicture.asset(
                    'assets/icons/fav.svg',
                    width: 22.w,
                    height: 22.h,
                    colorFilter: ColorFilter.mode(
                      isLiked ? AppColors.cRed : AppColors.cBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  '${post.likes.length}',
                  style: TextStyle(
                    color: AppColors.cBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                IconButton(
                  onPressed: onComment,
                  icon: SvgPicture.asset(
                    'assets/icons/chat.svg',
                    width: 22.w,
                    height: 22.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.cBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  '${post.commentCount}',
                  style: TextStyle(
                    color: AppColors.cBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                IconButton(
                  onPressed: onShare,
                  icon: SvgPicture.asset(
                    'assets/icons/export.svg',
                    width: 20.w,
                    height: 20.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.cBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColors.cBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
