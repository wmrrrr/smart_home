import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';

class LabsScreen extends StatelessWidget {
  const LabsScreen({super.key});

  static const _labs = [
    _LabEntry(
      number: 1,
      title: 'StatefulWidget & CI/CD',
      subtitle: 'Лічильник пристроїв, GitHub Actions',
      icon: Icons.exposure_plus_1,
      color: Color(0xFF1565C0),
      route: '/lab1',
    ),
    _LabEntry(
      number: 2,
      title: 'Navigation & Multi-screen UI',
      subtitle: 'go_router, 4 екрани, адаптивний макет',
      icon: Icons.navigation_outlined,
      color: Color(0xFF00695C),
      route: '/home',
    ),
    _LabEntry(
      number: 3,
      title: 'SharedPreferences & Auth',
      subtitle: 'Локальна автентифікація, repository pattern',
      icon: Icons.lock_person_outlined,
      color: Color(0xFF6A1B9A),
      route: '/profile',
    ),
    _LabEntry(
      number: 4,
      title: 'MQTT & Connectivity',
      subtitle: 'IoT датчики, mqtt_client, secure storage',
      icon: Icons.sensors,
      color: Color(0xFFE65100),
      route: '/lab4',
    ),
    _LabEntry(
      number: 5,
      title: 'HTTP & Open-Meteo API',
      subtitle: 'dio, погода Київ, офлайн кеш',
      icon: Icons.cloud_outlined,
      color: Color(0xFF0277BD),
      route: '/lab5',
    ),
    _LabEntry(
      number: 6,
      title: 'flutter_bloc (Cubit)',
      subtitle: '5 кубітів, sealed states, BLoC pattern',
      icon: Icons.device_hub,
      color: Color(0xFF2E7D32),
      route: '/home',
    ),
    _LabEntry(
      number: 7,
      title: 'Flutter Plugin (torch_control)',
      subtitle: 'Camera2 API, MethodChannel, PlatformInterface',
      icon: Icons.flashlight_on_outlined,
      color: Color(0xFFC62828),
      route: '/torch',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Smart Home — Лабораторні роботи'),
        actions: [
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.primaryContainer,
            child: Text(
              'IoT Smart Home Monitor · Flutter 3.44',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _labs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) => _LabCard(entry: _labs[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabEntry {
  const _LabEntry({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
}

class _LabCard extends StatelessWidget {
  const _LabCard({required this.entry});

  final _LabEntry entry;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => context.push(entry.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(entry.icon, color: entry.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lab ${entry.number}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: entry.color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.title,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: entry.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
