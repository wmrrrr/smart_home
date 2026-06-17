import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/core/widgets/app_button.dart';
import 'package:smart_home/core/widgets/app_text_field.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/cubits/auth/auth_state.dart';
import 'package:smart_home/cubits/connectivity/connectivity_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// StatefulWidget kept only for TextEditingControllers (allowed exception per lab spec)
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showOfflineDialog(final AuthCubit cubit) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Немає інтернету'),
        content: const Text('Увійти з поточною сесією?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Скасувати'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final state = cubit.state;
              if (state is AuthAuthenticated && context.mounted) {
                context.go('/home');
              }
            },
            child: const Text('Так'),
          ),
        ],
      ),
    );
  }

  void _submit(final BuildContext ctx) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final isConnected = ctx.read<ConnectivityCubit>().state;
    final auth = ctx.read<AuthCubit>();

    if (!isConnected) {
      _showOfflineDialog(auth);
      return;
    }
    auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
  }

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (state is AuthAuthenticated) ctx.go('/home');
      },
      builder: (ctx, state) {
        final theme = Theme.of(ctx);
        final screenWidth = MediaQuery.sizeOf(ctx).width;
        final horizontalPad = screenWidth > 600 ? screenWidth * 0.2 : 24.0;
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPad,
                vertical: 32,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Icon(
                      Icons.home_outlined,
                      size: 72,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Smart Home',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Вхід у систему',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    AppTextField(
                      label: 'Email',
                      controller: _emailCtrl,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Введіть email';
                        if (!v.contains('@')) return 'Невірний формат email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Пароль',
                      controller: _passwordCtrl,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return 'Мінімум 6 символів';
                        }
                        return null;
                      },
                    ),
                    if (state is AuthError) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppButton(
                      label: isLoading ? 'Завантаження...' : 'Увійти',
                      onPressed: isLoading ? null : () => _submit(ctx),
                      icon: Icons.login,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Реєстрація',
                      onPressed: () => ctx.push('/register'),
                      isOutlined: true,
                      icon: Icons.person_add_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
