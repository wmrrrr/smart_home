import 'package:go_router/go_router.dart';
import 'package:smart_home/data/models/user_model.dart';
import 'package:smart_home/features/auth/login_screen.dart';
import 'package:smart_home/features/auth/register_screen.dart';
import 'package:smart_home/features/home/home_screen.dart';
import 'package:smart_home/features/profile/edit_profile_screen.dart';
import 'package:smart_home/features/profile/profile_screen.dart';
import 'package:smart_home/features/torch/torch_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (ctx, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (ctx, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (ctx, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (ctx, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (ctx, state) => EditProfileScreen(
        user: state.extra! as UserModel,
      ),
    ),
    GoRoute(
      path: '/torch',
      builder: (ctx, state) => const TorchScreen(),
    ),
  ],
);
