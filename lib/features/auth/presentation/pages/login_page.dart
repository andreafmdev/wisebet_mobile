import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/error/error_handler.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isRegisterMode = false;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authNotifier = ref.read(authProvider.notifier);
      bool success;

      if (_isRegisterMode) {
        success = await authNotifier.register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      } else {
        success = await authNotifier.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (success && mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, 'Errore durante l\'accesso');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginAsGuest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).loginAsGuest();
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, 'Errore durante l\'accesso come guest');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Title
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: AppColors.accentGold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'WiseBet',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRegisterMode ? 'Crea un account' : 'Accedi al tuo account',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Name field (solo in registrazione)
                    if (_isRegisterMode) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Inserisci il tuo nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci la tua email';
                        }
                        if (!value.contains('@')) {
                          return 'Email non valida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password minimo 6 caratteri';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    PrimaryButton(
                      text: _isRegisterMode ? 'Registrati' : 'Accedi',
                      onPressed: _isLoading ? null : _handleSubmit,
                      isLoading: _isLoading,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 16),

                    // Toggle register/login
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegisterMode = !_isRegisterMode;
                        });
                      },
                      child: Text(
                        _isRegisterMode
                            ? 'Hai già un account? Accedi'
                            : 'Non hai un account? Registrati',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Guest login
                    OutlinedButton(
                      onPressed: _isLoading ? null : _loginAsGuest,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.accentGold),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continua come Guest',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

