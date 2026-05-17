import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkc_vender_auth/app/router/app_routes.dart';
import 'package:tkc_vender_auth/app/theme/app_colors.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_notifier.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_state.dart';
import 'package:tkc_vender_auth/features/auth/presentation/widgets/auth_form.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.state == AuthConcreteState.failure && next.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (next.state == AuthConcreteState.authenticated &&
          previous?.state != AuthConcreteState.authenticated) {
        Future(() async {
          final loaded = await ref.read(authProvider.notifier).fetchProfile();
          if (loaded && context.mounted) {
            context.goNamed(AppRoutes.home);
          }
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.logoGradientStart,
                          AppColors.logoGradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.logoGradientStart.withValues(
                            alpha: 0.28,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Vendor Auth',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to open mini apps',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AuthForm(
                    isLoading: authState.isLoading,
                    onSubmit: (username, password) async {
                      await ref
                          .read(authProvider.notifier)
                          .login(username: username, password: password);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
