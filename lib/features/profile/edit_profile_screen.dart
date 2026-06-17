import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home/core/widgets/app_button.dart';
import 'package:smart_home/core/widgets/app_text_field.dart';
import 'package:smart_home/cubits/auth/auth_cubit.dart';
import 'package:smart_home/data/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

// StatefulWidget kept for TextEditingControllers (allowed exception)
class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.user.name);
  late final _phoneCtrl = TextEditingController(text: widget.user.phone);
  late final _cityCtrl = TextEditingController(text: widget.user.city);
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);

    final updated = widget.user.copyWith(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
    );

    await context.read<AuthCubit>().updateUser(updated);
    if (mounted) context.pop();
  }

  @override
  Widget build(final BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPad = screenWidth > 600 ? screenWidth * 0.2 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Редагувати профіль')),
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
                  label: 'Телефон',
                  controller: _phoneCtrl,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Місто',
                  controller: _cityCtrl,
                  prefixIcon: Icons.location_city_outlined,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: _loading ? 'Збереження...' : 'Зберегти',
                  onPressed: _loading ? null : _save,
                  icon: Icons.save_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
