import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/app_colors.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final bool? isObscure;
  final bool? isCode;
  final String? title;
  final bool? isSearch;

  const TextFormFieldWidget({
    super.key,
    required this.text,
    required this.controller,
    this.isPassword,
    this.validator,
    this.isObscure,
    this.isCode,
    this.title,
    this.isSearch,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure ?? (widget.isPassword == true);
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentHintText =
        (widget.isSearch == true && _focusNode.hasFocus)
        ? 'Type something'
        : widget.text;

    return SizedBox(
      width: 315.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: TextStyle(
                color: AppColors.cBlack,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
          ],
          SizedBox(
            width: 315.w,
            child: TextFormField(
              obscureText: widget.isPassword == true ? _obscureText : false,
              controller: widget.controller,
              validator: widget.validator,
              focusNode: _focusNode,
              obscuringCharacter: '•',
              textAlign: widget.isCode == true
                  ? TextAlign.center
                  : TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 14.h,
                ),
                suffixIcon: widget.isPassword == true
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.cGrey3,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                prefixIcon: widget.isSearch == true
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.cDarkPurple,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : null,
                hintText: currentHintText,
                hintStyle: TextStyle(color: AppColors.cGrey4, fontSize: 14.sp),
                filled: true,
                fillColor: _focusNode.hasFocus
                    ? AppColors.cWhite
                    : AppColors.cGrey6,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: AppColors.cBlue, width: 1.5),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: AppColors.cRed, width: 1.5),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide(color: AppColors.cRed, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
