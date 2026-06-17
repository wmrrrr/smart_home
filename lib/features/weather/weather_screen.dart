import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/cubits/weather/weather_cubit.dart';
import 'package:smart_home/cubits/weather/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (ctx, state) => switch (state) {
        WeatherInitial() || WeatherLoading() =>
          const Center(child: CircularProgressIndicator()),
        WeatherLoaded(:final data, :final fromCache) =>
          _WeatherContent(data: data, fromCache: fromCache),
        WeatherError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: Theme.of(ctx).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => ctx.read<WeatherCubit>().fetch(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Спробувати знову'),
                  ),
                ],
              ),
            ),
          ),
      },
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.data, required this.fromCache});

  final dynamic data;
  final bool fromCache;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPad = screenWidth > 600 ? screenWidth * 0.2 : 16.0;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 24),
      children: [
        if (fromCache)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Chip(
              avatar: Icon(Icons.storage, size: 16),
              label: Text('Кешовані дані (офлайн)'),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => context.read<WeatherCubit>().fetch(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Оновити'),
          ),
        ),
        Center(
          child: Column(
            children: [
              Text(
                '${data.temperature.toStringAsFixed(1)}°C',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data.weatherDescription as String,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _MetricCard(
          icon: Icons.water_drop_outlined,
          label: 'Вологість',
          value: '${(data.humidity as double).toStringAsFixed(0)}%',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _MetricCard(
          icon: Icons.air,
          label: 'Вітер',
          value: '${(data.windSpeed as double).toStringAsFixed(1)} км/год',
          color: Colors.teal,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Open-Meteo API (Київ). Кешується для офлайн-доступу.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(40),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        trailing: Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
