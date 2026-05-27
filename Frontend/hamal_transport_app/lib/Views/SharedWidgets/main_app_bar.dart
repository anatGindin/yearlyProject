import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Services/authentication_service.dart';
import '../../Services/navigation_controller.dart';
import 'user_avatar.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;

  const MainAppBar({super.key, this.title, this.titleWidget, this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final userProfile = AuthenticationService().currentUserProfile;
    final userName = userProfile?.name ?? '';

    final isDark = theme.brightness == Brightness.dark;
    final barColor = isDark
        ? (theme.appBarTheme.backgroundColor ?? const Color(0xFF1E293B))
        : theme.colorScheme.primary;

    return AppBar(
      backgroundColor: barColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leadingWidth: isLandscape ? 80 : kToolbarHeight,
      leading: InkWell(
        onTap: () {
          context.read<MainNavigationController>().navigateTo(
            NavBarPageType.profile,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserAvatar(
            name: userName,
            radius: 18,
            backgroundColor: theme.colorScheme.surface,
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null),
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            // TODO: Implement notification tap
          },
        ),
      ],
      iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
