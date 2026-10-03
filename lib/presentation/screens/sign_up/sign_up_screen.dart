import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_router/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../common_widgets/full_size_button_unclicked.dart';
import '../../common_widgets/text_form_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signUp(
      fullName: _nameController.text.trim(),
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.cBlack,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Create Account',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.cBlack,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Join ConnectMe and discover your people',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.cGrey3,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      TextFormFieldWidget(
                        title: 'Full Name',
                        text: 'Enter your full name',
                        controller: _nameController,
                        validator: Validators.fullName,
                      ),

                      SizedBox(height: 14.h),

                      TextFormFieldWidget(
                        title: 'Email',
                        text: 'Enter your email',
                        controller: _emailController,
                        validator: Validators.email,
                      ),

                      SizedBox(height: 14.h),

                      TextFormFieldWidget(
                        title: 'Password',
                        text: 'Enter at least 6 characters',
                        controller: _passwordController,
                        isPassword: true,
                        isObscure: true,
                        validator: Validators.password,
                      ),

                      SizedBox(height: 14.h),

                      TextFormFieldWidget(
                        title: 'Confirm Password',
                        text: 'Re-enter your password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        isObscure: true,
                        validator: (val) => Validators.confirmPassword(
                          _passwordController.text,
                        )(val),
                      ),

                      SizedBox(height: 28.h),

                      FullSizeButtonUnClicked(
                        onPressed: _onSignUp,
                        text: 'Sign Up',
                        isLoading: isLoading,
                      ),

                      SizedBox(height: 24.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.cGrey2,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.cDarkPurple,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
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
