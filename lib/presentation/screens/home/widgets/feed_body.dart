import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclick/presentation/screens/home/widgets/story_item.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../blocs/auth/auth_cubit.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/post/post_cubit.dart';
import '../../../blocs/post/post_state.dart';
import '../../../common_widgets/post_card.dart';
import 'add_story_item.dart';

class FeedBody extends StatelessWidget {
  Function()? onProfileTap;

  FeedBody({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<PostCubit>().fetchPostsOnce();
      },
      color: AppColors.cDarkPurple,
      child: CustomScrollView(
        slivers: [
          // --- Stories / Creators Horizontal List ---
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.cWhite,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SizedBox(
                height: 94.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  children: [
                    AddStoryItem(),
                    StoryItem(
                      name: 'Elena',
                      imageUrl:
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                    ),
                    StoryItem(
                      name: 'Marcus',
                      imageUrl:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                    ),
                    StoryItem(
                      name: 'Sophia',
                      imageUrl:
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
                    ),
                    StoryItem(
                      name: 'Liam',
                      imageUrl:
                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 6.h)),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoading || state is PostInitial) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.cDarkPurple,
                    ),
                  ),
                );
              }

              if (state is PostLoaded) {
                final posts = state.posts;
                if (posts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dynamic_feed_rounded,
                            size: 56.sp,
                            color: AppColors.cGrey4,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No community posts yet',
                            style: TextStyle(
                              color: AppColors.cGrey3,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Be the first to share something!',
                            style: TextStyle(
                              color: AppColors.cGrey4,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final currentUserId =
                    (context.read<AuthCubit>().state is AuthAuthenticated)
                    ? (context.read<AuthCubit>().state as AuthAuthenticated)
                          .user
                          .id
                    : 'guest';

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = posts[index];
                    return PostCard(
                      post: post,
                      currentUserId: currentUserId,
                      onLike: () {
                        context.read<PostCubit>().toggleLike(
                          postId: post.id,
                          userId: currentUserId,
                        );
                      },
                      onProfileTap: onProfileTap,
                    );
                  }, childCount: posts.length),
                );
              }

              return const SliverFillRemaining(
                child: Center(child: Text('Unable to load feed.')),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }
}
