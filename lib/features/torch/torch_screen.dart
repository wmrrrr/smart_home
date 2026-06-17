import 'dart:io';
import 'package:flutter/material.dart';
import 'package:torch_control/torch_control.dart';

class TorchScreen extends StatefulWidget {
  const TorchScreen({super.key});

  @override
  State<TorchScreen> createState() => _TorchScreenState();
}

class _TorchScreenState extends State<TorchScreen> {
  bool _torchOn = false;
  bool _available = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    if (Platform.isIOS) {
      setState(() => _loading = false);
      _showUnsupportedDialog();
      return;
    }
    try {
      final available = await TorchControl.isAvailable();
      setState(() {
        _available = available;
        _loading = false;
      });
    } on Exception catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _showUnsupportedDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Не підтримується'),
          content: const Text(
            'Управління ліхтариком доступне лише на Android.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _toggle() async {
    try {
      if (_torchOn) {
        await TorchControl.turnOff();
      } else {
        await TorchControl.turnOn();
      }
      setState(() => _torchOn = !_torchOn);
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Future<void> dispose() async {
    if (_torchOn) await TorchControl.turnOff();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ліхтарик')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Platform.isIOS) ...[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 72,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Функція недоступна на iOS',
                      style: TextStyle(fontSize: 18),
                    ),
                  ] else if (!_available) ...[
                    Icon(
                      Icons.flashlight_off,
                      size: 72,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    const Text('Ліхтарик недоступний на цьому пристрої'),
                  ] else ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _torchOn
                            ? Colors.yellow.shade200
                            : theme.colorScheme.surfaceContainerHighest,
                        boxShadow: _torchOn
                            ? [
                                BoxShadow(
                                  color: Colors.yellow.withAlpha(120),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        _torchOn
                            ? Icons.flashlight_on
                            : Icons.flashlight_off,
                        size: 72,
                        color: _torchOn
                            ? Colors.amber.shade800
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _torchOn ? 'Увімкнено' : 'Вимкнено',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _toggle,
                      icon: Icon(
                        _torchOn ? Icons.toggle_on : Icons.toggle_off,
                      ),
                      label: Text(_torchOn ? 'Вимкнути' : 'Увімкнути'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _torchOn
                            ? Colors.amber
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
