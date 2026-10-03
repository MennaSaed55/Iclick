import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../domain/entities/user_entity.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../common_widgets/full_size_button_unclicked.dart';
import '../../common_widgets/text_form_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final UserEntity? user;

  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName ?? '');
    _bioController = TextEditingController(text: widget.user?.bio ?? '');
    _locationController = TextEditingController(
      text: widget.user?.location ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final userId = widget.user?.id;
    if (userId == null) return;

    context.read<ProfileCubit>().saveProfile(
      userId: userId,
      fullName: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );
    showSuccessSnackBar(context, 'Profile updated successfully!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isLoading = state is ProfileUpdating;

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
            title: Text(
              'Edit Profile',
              style: GoogleFonts.inter(
                color: AppColors.cBlack,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      title: 'Full Name',
                      text: 'Enter your name',
                      controller: _nameController,
                      validator: Validators.fullName,
                    ),
                    SizedBox(height: 16.h),
                    TextFormFieldWidget(
                      title: 'Bio',
                      text: 'Tell the community about yourself',
                      controller: _bioController,
                    ),
                    SizedBox(height: 16.h),
                    TextFormFieldWidget(
                      title: 'Location',
                      text: 'e.g. San Francisco, CA',
                      controller: _locationController,
                    ),
                    SizedBox(height: 36.h),
                    FullSizeButtonUnClicked(
                      onPressed: _onSave,
                      text: 'Save Changes',
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
