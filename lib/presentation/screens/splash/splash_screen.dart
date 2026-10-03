import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuthStatus();
    });
  }

  void _onGetStarted(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRouter.home.path);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'assets/images/iclick.png',
                  height: 38.h,
                  errorBuilder: (context, error, stackTrace) => Text(
                    'ConnectMe',
                    style: GoogleFonts.inter(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.cWhite,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                Image.asset(
                  'assets/images/image.png',
                  height: 280.h,
                  fit: BoxFit.contain,
                ),

                const Spacer(flex: 1),

                Text(
                  'SHARE - INSPIRE - CONNECT',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    color: AppColors.cWhite,
                  ),
                ),

                SizedBox(height: 30.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: SizedBox(
                    width: 315.w,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () => _onGetStarted(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cWhite.withValues(
                          alpha: 0.25,
                        ),
                        foregroundColor: AppColors.cWhite,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                            color: AppColors.cWhite.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.inter(
                          color: AppColors.cWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
