import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/core/widgets/app_button.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/cubits/auth/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (ctx, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final theme = Theme.of(ctx);
        final screenWidth = MediaQuery.sizeOf(ctx).width;
        final horizontalPad = screenWidth > 600 ? screenWidth * 0.2 : 16.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профіль'),
            actions: [
              if (user != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Редагувати',
                  onPressed: () => ctx.push('/profile/edit', extra: user),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPad,
              vertical: 24,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? '—',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? '—',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if ((user?.phone ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(user!.phone, style: theme.textTheme.bodySmall),
                ],
                if ((user?.city ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(user!.city, style: theme.textTheme.bodySmall),
                ],
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                _SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'Сповіщення',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.security_outlined,
                  title: 'Безпека',
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Вийти',
                  onPressed: () async {
                    await ctx.read<AuthCubit>().logout();
                    if (ctx.mounted) ctx.go('/');
                  },
                  isOutlined: true,
                  icon: Icons.logout,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
