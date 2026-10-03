import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

/// A reusable text field that follows ConnectMe's design system.
///
/// Wraps [TextFormField] with consistent styling, label display,
/// error handling, and password toggle support.
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int? maxLines;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.inputLabel),
        const SizedBox(height: AppSizes.xs),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && _obscureText,
          readOnly: widget.readOnly,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            suffixIcon: widget.isPassword
                ? _buildPasswordToggle()
                : (widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: widget.suffixIcon,
                        )
                      : null),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordToggle() {
    return IconButton(
      onPressed: () => setState(() => _obscureText = !_obscureText),
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: AppColors.textSecondary,
        size: AppSizes.iconMd,
      ),
    );
  }
}
