import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_registry.dart';
import 'package:tkc_vender_auth/app/theme/app_colors.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_notifier.dart';
import 'package:tkc_vender_auth/features/home/presentation/widgets/mini_app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _initials(String username, String displayName) {
    final userMatch = RegExp(
      r'user(\d+)',
      caseSensitive: false,
    ).firstMatch(username);
    if (userMatch != null) {
      return 'U${userMatch.group(1)}';
    }
    if (displayName.isNotEmpty) {
      final parts = displayName.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName.substring(0, 1).toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final displayName = user?.displayName ?? 'User';
    final username = user?.username ?? '';
    final initials = _initials(username, displayName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mini Apps'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width < 600
                ? 2
                : width < 900
                ? 3
                : 4;
            final horizontalPadding = width < 600 ? 20.0 : width * 0.08;

            return ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                16,
              ),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_greeting()},',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  letterSpacing: -0.6,
                                  color: AppColors.textPrimary,
                                  height: 1.15,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        initials,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, thickness: 1, color: AppColors.border),
                const SizedBox(height: 20),
                Text(
                  'Mini Apps',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    for (final app in miniAppRegistry)
                      MiniAppCard(
                        title: app.title,
                        subtitle: app.subtitle,
                        icon: app.icon,
                        color: app.color,
                        onTap: () => context.pushNamed(app.entryRouteName),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
