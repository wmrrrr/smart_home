import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/core/widgets/device_card.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/cubits/auth/auth_state.dart';
import 'package:smart_home/cubits/connectivity/connectivity_cubit.dart';
import 'package:smart_home/cubits/devices/devices_cubit.dart';
import 'package:smart_home/cubits/devices/devices_state.dart';
import 'package:smart_home/features/sensors/sensor_screen.dart';
import 'package:smart_home/features/weather/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabTitles = ['Smart Home', 'IoT Датчики', 'Погода'];

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (_) => _HomeTabCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeTabCubit extends Cubit<int> {
  _HomeTabCubit() : super(0);
  void selectTab(final int i) => emit(i);
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(final BuildContext context) {
    final tabIndex = context.watch<_HomeTabCubit>().state;
    final isConnected = context.watch<ConnectivityCubit>().state;
    final authState = context.watch<AuthCubit>().state;
    final userName = authState is AuthAuthenticated
        ? authState.user.name
        : 'користувач';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text(HomeScreen._tabTitles[tabIndex]),
        actions: [
          Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: isConnected ? Colors.greenAccent : Colors.red.shade200,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.flashlight_on_outlined),
            tooltip: 'Ліхтарик',
            onPressed: () => context.push('/torch'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Профіль',
            onPressed: () => context.push('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Вийти',
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: tabIndex,
        children: [
          _DevicesTab(userName: userName),
          const SensorScreen(),
          const WeatherScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: context.read<_HomeTabCubit>().selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Дім',
          ),
          NavigationDestination(
            icon: Icon(Icons.sensors_outlined),
            selectedIcon: Icon(Icons.sensors),
            label: 'Датчики',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Погода',
          ),
        ],
      ),
    );
  }
}

class _DevicesTab extends StatelessWidget {
  const _DevicesTab({required this.userName});

  final String userName;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossCount = screenWidth > 600 ? 4 : 2;

    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (ctx, devicesState) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.sensors,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Вітаємо, $userName!',
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            'Активних: ${devicesState.activeCount} / ${devicesState.devices.length}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Пристрої', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: devicesState.devices.length,
                itemBuilder: (gridCtx, i) {
                  final device = devicesState.devices[i];
                  return DeviceCard(
                    name: device.name,
                    icon: device.icon,
                    isActive: device.isActive,
                    onTap: () => ctx.read<DevicesCubit>().toggle(device.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
