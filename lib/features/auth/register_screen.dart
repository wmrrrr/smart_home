import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/core/widgets/app_button.dart';
import 'package:smart_home/core/widgets/app_text_field.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/cubits/auth/auth_state.dart';
import 'package:smart_home/data/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// StatefulWidget kept only for TextEditingControllers
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit(final BuildContext ctx) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ctx.read<AuthCubit>().register(
          UserModel(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            passwordHash: _passwordCtrl.text,
          ),
        );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (state is AuthUnauthenticated) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Акаунт створено! Увійдіть.')),
          );
          ctx.go('/');
        }
      },
      builder: (ctx, state) {
        final theme = Theme.of(ctx);
        final screenWidth = MediaQuery.sizeOf(ctx).width;
        final horizontalPad = screenWidth > 600 ? screenWidth * 0.2 : 24.0;
        final isLoading = state is AuthLoading;

        return Scaffold(
          appBar: AppBar(title: const Text('Реєстрація')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPad,
                vertical: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: "Ім'я",
                      controller: _nameCtrl,
                      prefixIcon: Icons.person_outline,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Введіть ім'я";
                        }
                        if (RegExp(r'\d').hasMatch(v)) {
                          return "Ім'я не має містити цифр";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email',
                      controller: _emailCtrl,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Введіть email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return 'Невірний формат email';
                        }
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
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Підтвердження паролю',
                      controller: _confirmCtrl,
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) {
                        if (v != _passwordCtrl.text) {
                          return 'Паролі не збігаються';
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
                      label: isLoading ? 'Завантаження...' : 'Зареєструватись',
                      onPressed: isLoading ? null : () => _submit(ctx),
                      icon: Icons.check,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Вже маю акаунт',
                      onPressed: () => ctx.pop(),
                      isOutlined: true,
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
