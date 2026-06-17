import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/core/services/mqtt_service.dart';
import 'package:smart_home/cubits/connectivity/connectivity_cubit.dart';
import 'package:smart_home/cubits/sensors/sensors_cubit.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final isConnected = context.watch<ConnectivityCubit>().state;
    final readings = context.watch<SensorsCubit>().state;

    return Column(
      children: [
        if (!isConnected)
          MaterialBanner(
            content: const Text('Офлайн — показуємо симульовані дані'),
            leading: const Icon(Icons.warning_amber, color: Colors.orange),
            backgroundColor: Colors.orange.shade50,
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('OK'),
              ),
            ],
          ),
        Expanded(
          child: readings.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SensorTile(
                      title: 'Температура',
                      icon: Icons.thermostat,
                      reading: readings['smarthome/temperature'],
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _SensorTile(
                      title: 'Вологість',
                      icon: Icons.water_drop_outlined,
                      reading: readings['smarthome/humidity'],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _SensorTile(
                      title: 'Тиск',
                      icon: Icons.compress,
                      reading: readings['smarthome/pressure'],
                      color: Colors.purple,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _SensorTile extends StatelessWidget {
  const _SensorTile({
    required this.title,
    required this.icon,
    required this.reading,
    required this.color,
  });

  final String title;
  final IconData icon;
  final SensorReading? reading;
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
        title: Text(title),
        trailing: reading != null
            ? Text(
                '${reading!.value} ${reading!.unit}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
      ),
    );
  }
}
