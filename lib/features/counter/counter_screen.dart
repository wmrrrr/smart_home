import 'package:flutter/material.dart';
import 'package:smart_home/features/counter/counter_controller.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final _controller = CounterController();
  final _inputController = TextEditingController();
  String? _errorMessage;

  void _handleAction() {
    final text = _inputController.text;

    if (_controller.isResetCommand(text)) {
      setState(() {
        _controller.reset();
        _errorMessage = null;
      });
      _inputController.clear();
      return;
    }

    final success = _controller.tryIncrement(text);
    setState(() {
      _errorMessage = success ? null : 'Введіть ціле число або "reset"';
    });

    if (success) _inputController.clear();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Smart Home — Lab 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Лічильник пристроїв',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '${_controller.value}',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Введіть число або "reset"',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _inputController.clear();
                    setState(() => _errorMessage = null);
                  },
                ),
              ),
              onSubmitted: (_) => _handleAction(),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _handleAction,
              icon: const Icon(Icons.add),
              label: const Text('Застосувати'),
            ),
          ],
        ),
      ),
    );
  }
}
