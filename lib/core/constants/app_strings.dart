/// ConnectMe application-wide string constants.
///
/// Centralizing strings enables easy localization in future phases
/// and prevents magic string duplication across the codebase.
class AppStrings {
  AppStrings._();

  // --- App Identity ---
  static const String appName = 'ConnectMe';
  static const String appTagline = 'Share. Discover. Connect.';

  // --- Auth ---
  static const String login = 'Sign In';
  static const String signUp = 'Create Account';
  static const String logout = 'Sign Out';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String sendResetEmail = 'Send Reset Email';

  static const String email = 'Email';
  static const String emailHint = 'your@email.com';
  static const String password = 'Password';
  static const String passwordHint = 'Min. 6 characters';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String fullNameHint = 'Your full name';

  static const String dontHaveAccount = "Don't have an account?";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signUpLink = 'Sign Up';
  static const String signInLink = 'Sign In';

  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Sign in to continue your journey';
  static const String createAccountTitle = 'Join ConnectMe';
  static const String createAccountSubtitle = 'Connect with your community';
  static const String resetPasswordTitle = 'Reset Password';
  static const String resetPasswordSubtitle =
      "Enter your email and we'll send you a reset link.";
  static const String resetEmailSent = 'Reset email sent! Check your inbox.';

  // --- Navigation ---
  static const String home = 'Home';
  static const String search = 'Search';
  static const String create = 'Create';
  static const String activity = 'Activity';
  static const String profile = 'Profile';

  // --- Errors ---
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Check your network.';
  static const String errorInvalidEmail = 'Please enter a valid email address.';
  static const String errorWeakPassword =
      'Password must be at least 6 characters.';
  static const String errorPasswordMismatch = 'Passwords do not match.';
  static const String errorRequiredField = 'This field is required.';
  static const String errorFullNameFormat =
      'First character must be uppercase.';
  static const String errorIncorrectCredentials =
      'Incorrect email or password.';
  static const String errorEmailInUse =
      'An account already exists for this email.';
  static const String errorUserNotFound = 'No account found for this email.';
  static const String errorTooManyRequests =
      'Too many attempts. Please try again later.';
  static const String errorAccountDisabled = 'This account has been disabled.';
  static const String errorBiometricCancelled =
      'Biometric authentication was cancelled.';
  static const String errorBiometricNotAvailable =
      'Biometric authentication is not available on this device.';
  static const String errorProfileImageUpload =
      'Profile photo upload failed. Please try again.';
  static const String errorLoadingPosts =
      'Unable to load community posts. Please try again.';
  static const String errorCreateAccount =
      'Unable to create your account. Please try again.';
}
