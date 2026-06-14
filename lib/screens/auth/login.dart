import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pep/widget/bottomrectangularbtn.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _selectedRole = 'rider';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final phone = '+234${_phoneController.text.trim().replaceFirst(RegExp(r'^0'), '')}';
    final ok = await auth.sendOtp(phone, role: _selectedRole);
  
    
    if (ok) {
      if (!mounted) return;
      context.push('/otp', extra: {'phone': phone, 'role': _selectedRole});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Failed to send OTP'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.directions_car, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Welcome to\nRideX',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your phone number to continue',
                  style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 40),

                // Role selector
                Row(
                  children: [
                    _RoleChip(
                      label: '🧑 Rider',
                      selected: _selectedRole == 'rider',
                      onTap: () => setState(() => _selectedRole = 'rider'),
                    ),
                    const SizedBox(width: 12),
                    _RoleChip(
                      label: '🚗 Driver',
                      selected: _selectedRole == 'driver',
                      onTap: () => setState(() => _selectedRole = 'driver'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '08012345678',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Text('🇳🇬 +234', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your phone number';
                    if (v.length < 10) return 'Enter a valid phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                BottomRectangularBtn(onTapFunc: () {  }, btnTitle: 'Login',),

                Center(
                  child: Text(
                    'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppTheme.textHint, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.black : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.black : AppTheme.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}