import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../common_widgets/full_size_button_unclicked.dart';
import '../../common_widgets/text_form_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRouter.home.path);
        } else if (state is AuthError) {
          showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.cWhite,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- App Brand Logo / Icon ---
                      Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cDarkPurple.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.hub_rounded,
                            color: AppColors.cWhite,
                            size: 34.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // --- Title & Subtitle ---
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.cBlack,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Sign in to explore your community',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.cGrey3,
                        ),
                      ),

                      SizedBox(height: 36.h),

                      // --- Email Field (Figma Pill Style) ---
                      TextFormFieldWidget(
                        title: 'Email',
                        text: 'Enter your email',
                        controller: _emailController,
                        validator: Validators.email,
                      ),

                      SizedBox(height: 16.h),

                      // --- Password Field (Figma Pill Style) ---
                      TextFormFieldWidget(
                        title: 'Password',
                        text: 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: Validators.password,
                      ),

                      // --- Forgot Password Link ---
                      SizedBox(
                        width: 315.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.forgotPassword.path,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.cBlue,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // --- Gradient Sign In Button ---
                      FullSizeButtonUnClicked(
                        onPressed: _onSignIn,
                        text: 'Sign In',
                        isLoading: isLoading,
                      ),

                      SizedBox(height: 24.h),

                      // --- "or" Divider ---
                      SizedBox(
                        width: 315.w,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(color: AppColors.cGrey5),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: Text(
                                'or connect with',
                                style: TextStyle(
                                  color: AppColors.cGrey3,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: AppColors.cGrey5),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // --- Social Logins ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            asset: 'assets/icons/facebook-fill.svg',
                            color: const Color(0xFF1877F2),
                            onTap: () {},
                          ),
                          SizedBox(width: 16.w),
                          _SocialButton(
                            icon: Icons.g_mobiledata_rounded,
                            iconColor: AppColors.cRed,
                            onTap: () {},
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // --- Sign Up Link ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.cGrey2,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.signUp.path,
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.cDarkPurple,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    this.asset,
    this.icon,
    this.color,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: AppColors.cWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cGrey5, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.cBlack.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: asset != null
              ? SvgPicture.asset(asset!, width: 24.w, height: 24.h)
              : Icon(icon, size: 32.sp, color: iconColor ?? AppColors.cBlack),
        ),
      ),
    );
  }
}
