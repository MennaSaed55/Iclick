import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../injection.dart';
import '../../presentation/blocs/auth/auth_cubit.dart';
import '../../presentation/blocs/post/post_cubit.dart';
import '../../presentation/blocs/profile/profile_cubit.dart';
import '../../presentation/screens/forgot_password/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/sign_up/sign_up_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const SplashScreen(),
          ),
        );

      case '/login':
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );

      case '/sign-up':
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const SignUpScreen(),
          ),
        );

      case '/forgot-password':
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<AuthCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case '/home':
        return _buildRoute(
          settings,
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<PostCubit>()),
              BlocProvider(create: (_) => sl<ProfileCubit>()),
              BlocProvider(create: (_) => sl<AuthCubit>()),
            ],
            child: const HomeScreen(),
          ),
        );

      case '/profile':
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );

      case '/edit-profile':
        final user = settings.arguments as UserEntity?;
        return _buildRoute(
          settings,
          BlocProvider(
            create: (_) => sl<ProfileCubit>(),
            child: EditProfileScreen(user: user),
          ),
        );

      case '/map':
        return _buildRoute(settings, const MapScreen());

      case '/settings':
        return _buildRoute(settings, const SettingsScreen());

      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
