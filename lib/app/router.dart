import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/data/models/user_model.dart';
import 'package:smart_home/features/auth/login_screen.dart';
import 'package:smart_home/features/auth/register_screen.dart';
import 'package:smart_home/features/counter/counter_screen.dart';
import 'package:smart_home/features/home/home_screen.dart';
import 'package:smart_home/features/labs/labs_screen.dart';
import 'package:smart_home/features/profile/edit_profile_screen.dart';
import 'package:smart_home/features/profile/profile_screen.dart';
import 'package:smart_home/features/sensors/sensor_screen.dart';
import 'package:smart_home/features/torch/torch_screen.dart';
import 'package:smart_home/features/weather/weather_screen.dart';

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
      path: '/labs',
      builder: (ctx, state) => const LabsScreen(),
    ),
    GoRoute(
      path: '/lab1',
      builder: (ctx, state) => const CounterScreen(),
    ),
    GoRoute(
      path: '/lab4',
      builder: (ctx, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Lab 4 — MQTT & Connectivity'),
        ),
        body: const SensorScreen(),
      ),
    ),
    GoRoute(
      path: '/lab5',
      builder: (ctx, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Lab 5 — HTTP & Weather API'),
        ),
        body: const WeatherScreen(),
      ),
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
