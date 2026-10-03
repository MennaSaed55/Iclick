import '../../core/constants/app_strings.dart';

/// String validation extension methods.
///
/// Keeping validation logic on [String] extension prevents
/// duplicating it across form fields and screens.
extension StringValidators on String? {
  /// True if null or blank.
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// True if this is a non-null, non-empty string.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Validates email format.
  bool get isValidEmail {
    if (isNullOrEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this!.trim());
  }

  /// Validates password meets minimum strength requirements.
  bool get isValidPassword {
    if (isNullOrEmpty) return false;
    return this!.length >= 6;
  }

  /// Validates full name — non-empty and first character is uppercase.
  bool get isValidFullName {
    if (isNullOrEmpty) return false;
    final trimmed = this!.trim();
    if (trimmed.isEmpty) return false;
    return trimmed[0] == trimmed[0].toUpperCase() &&
        trimmed[0] != trimmed[0].toLowerCase();
  }
}

/// Centralized form field validator functions.
///
/// Returning a nullable String matches Flutter's [FormField.validator] signature.
/// Returning null = valid, returning a String = error message.
class Validators {
  Validators._();

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorRequiredField;
    }
    return null;
  }

  static String? email(String? value) {
    final required = requiredField(value);
    if (required != null) return required;
    if (!value.isValidEmail) return AppStrings.errorInvalidEmail;
    return null;
  }

  static String? password(String? value) {
    final required = requiredField(value);
    if (required != null) return required;
    if (!value.isValidPassword) return AppStrings.errorWeakPassword;
    return null;
  }

  static String? Function(String?) confirmPassword(String? original) {
    return (String? value) {
      final required = requiredField(value);
      if (required != null) return required;
      if (value != original) return AppStrings.errorPasswordMismatch;
      return null;
    };
  }

  static String? fullName(String? value) {
    final required = requiredField(value);
    if (required != null) return required;
    if (!value.isValidFullName) return AppStrings.errorFullNameFormat;
    return null;
  }
}
