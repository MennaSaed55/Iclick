import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iclick/presentation/screens/forgot_password/widgets/success_view.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../blocs/auth/auth_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../common_widgets/full_size_button_unclicked.dart';
import '../../common_widgets/text_form_field_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final isSent = state is AuthPasswordResetSent;

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
                child: isSent
                    ? SuccessView()
                    : Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.cPurple.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.lock_reset_rounded,
                                  color: AppColors.cDarkPurple,
                                  size: 40.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Reset Password',
                              style: GoogleFonts.inter(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cBlack,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Enter your email address and we will send you a password recovery link.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: AppColors.cGrey3,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            TextFormFieldWidget(
                              title: 'Email Address',
                              text: 'Enter your registered email',
                              controller: _emailController,
                              validator: Validators.email,
                            ),
                            SizedBox(height: 28.h),
                            FullSizeButtonUnClicked(
                              onPressed: _onReset,
                              text: 'Send Reset Link',
                              isLoading: isLoading,
                            ),
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
