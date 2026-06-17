import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/app/router.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/cubits/connectivity/connectivity_cubit.dart';
import 'package:smart_home/cubits/devices/devices_cubit.dart';
import 'package:smart_home/cubits/sensors/sensors_cubit.dart';
import 'package:smart_home/cubits/weather/weather_cubit.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ConnectivityCubit()),
        BlocProvider(create: (_) => DevicesCubit()),
        BlocProvider(create: (_) => WeatherCubit()),
        BlocProvider(create: (_) => SensorsCubit()),
      ],
      child: MaterialApp.router(
        title: 'Smart Home',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
