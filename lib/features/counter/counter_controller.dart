class CounterController {
  int _value = 0;

  int get value => _value;

  bool tryIncrement(final String input) {
    if (input.trim().isEmpty) {
      _value++;
      return true;
    }
    final parsed = int.tryParse(input.trim());
    if (parsed == null) return false;
    _value += parsed;
    return true;
  }

  void reset() => _value = 0;

  bool isResetCommand(final String input) =>
      input.trim().toLowerCase() == 'reset';
}
