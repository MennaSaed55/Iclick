import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iclick/presentation/screens/home/widgets/app_bar.dart';
import 'package:iclick/presentation/screens/home/widgets/bottom_nav.dart';
import 'package:iclick/presentation/screens/home/widgets/feed_body.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/post/post_cubit.dart';
import '../../blocs/profile/profile_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().loadPosts();
  }

  Future<void> _onProfileNavTap() async {
    final authenticated = await context
        .read<ProfileCubit>()
        .authenticateWithBiometrics();

    if (!mounted) return;

    if (authenticated) {
      Navigator.pushNamed(context, AppRouter.profile.path);
    } else {
      showErrorSnackBar(
        context,
        'Biometric authentication was cancelled or failed.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRouter.login.path);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBarCustom(
          confirmSignOut: _confirmSignOut,
          showCreatePostDialog: _showCreatePostDialog,
          onProfileTap: _onProfileNavTap,
        ),
        body: FeedBody(onProfileTap: _onProfileNavTap),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreatePostDialog,
          backgroundColor: AppColors.cDarkPurple,
          elevation: 4,
          child: const Icon(Icons.add, color: AppColors.cWhite, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNav(
          currentNavIndex: _currentNavIndex,
          onProfileNavTap: _onProfileNavTap,
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    final contentController = TextEditingController();
    final locationController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.cGrey5,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Create Community Post',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.cBlack,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts, projects, or moments...',
                filled: true,
                fillColor: AppColors.cGrey6,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Add location (optional)',
                prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                filled: true,
                fillColor: AppColors.cGrey6,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  final text = contentController.text.trim();
                  if (text.isEmpty) return;

                  final authState = context.read<AuthCubit>().state;
                  String authorId = 'guest';
                  String authorName = 'Community Member';

                  if (authState is AuthAuthenticated) {
                    authorId = authState.user.id;
                    authorName = authState.user.fullName;
                  }

                  context.read<PostCubit>().createPost(
                    authorId: authorId,
                    authorName: authorName,
                    content: text,
                    location: locationController.text.trim(),
                    imageUrl:
                        'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=800',
                  );

                  Navigator.pop(modalContext);
                  showSuccessSnackBar(context, 'Post shared with community!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cDarkPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Post Now',
                  style: TextStyle(
                    color: AppColors.cWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AuthCubit>().signOut();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.cRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
