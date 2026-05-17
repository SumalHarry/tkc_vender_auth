import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkc_vender_auth/app/theme/app_colors.dart';

class AuthForm extends HookConsumerWidget {
  const AuthForm({super.key, required this.onSubmit, required this.isLoading});

  final Future<void> Function(String username, String password) onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final submitted = useState(false);

    final usernameError = useMemoized(() {
      if (!submitted.value) return null;
      if (usernameController.text.trim().isEmpty) {
        return 'Username is required';
      }
      return null;
    }, [submitted.value, usernameController.text]);

    final passwordError = useMemoized(() {
      if (!submitted.value) return null;
      if (passwordController.text.isEmpty) {
        return 'Password is required';
      }
      return null;
    }, [submitted.value, passwordController.text]);

    final isValid =
        usernameController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'USERNAME',
            hintText: 'username',
          ),
          textInputAction: TextInputAction.next,
        ),
        if (usernameError != null) ...[
          const SizedBox(height: 4),
          Text(usernameError, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary)),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'PASSWORD',
            hintText: 'password',
          ),
          obscureText: true,
          onSubmitted: (_) async {
            if (!isValid || isLoading) return;
            submitted.value = true;
            await onSubmit(
              usernameController.text.trim(),
              passwordController.text,
            );
          },
        ),
        if (passwordError != null) ...[
          const SizedBox(height: 4),
          Text(passwordError, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary)),
        ],
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  submitted.value = true;
                  await onSubmit(
                    usernameController.text.trim(),
                    passwordController.text,
                  );
                },
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Sign In'),
        ),
      ],
    );
  }
}
