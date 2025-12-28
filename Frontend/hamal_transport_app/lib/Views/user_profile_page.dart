import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/logout_button.dart';
import 'package:hamal_transport_app/Views/Widgets/user_avatar.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  @override
  createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, _) {
          final topPadding = MediaQuery.of(context).padding.top + 15;

          return Stack(
            children: [
              // Top Section (Avatar + Info)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondaryContainer,
                      ],
                    ),
                  ),
                  height: 350,
                  child: Stack(
                    children: [
                      Positioned(
                        top: topPadding,
                        left: 8,
                        child: BackButton(color: theme.colorScheme.onSecondary),
                      ),
                      Positioned(
                        top: topPadding,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UserAvatar(
                              name: userProfileVM.name,
                              radius: 50,
                              backgroundColor: theme.colorScheme.surface,
                              textStyle: theme.textTheme.headlineLarge
                                  ?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              userProfileVM.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userProfileVM.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Section (Navigation Items)
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.35,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Page 0: Main Menu
                      ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          _buildProfileItem(
                            icon: Icons.person_outline,
                            title: l10n.accountInformation,
                            theme: theme,
                            onTap: () {
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                          const Divider(),
                          const SizedBox(height: 16),
                          const LogoutButton(),
                        ],
                      ),
                      // Page 1: Account Information details
                      _buildAccountInfoDetails(
                        context,
                        userProfileVM,
                        theme,
                        l10n,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountInfoDetails(
    BuildContext context,
    UserProfileViewModel vm,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        // Internal Header for the slide-in view
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              Text(
                l10n.accountInformation,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildInfoRow(Icons.person, l10n.name, vm.name, theme),
              const Divider(),
              _buildInfoRow(Icons.email, l10n.email, vm.email, theme),
              const Divider(),
              _buildInfoRow(Icons.phone, l10n.phone, vm.phone, theme),
              const Divider(),
              _buildInfoRow(Icons.work, l10n.role, vm.role(l10n), theme),
              if (vm.isDriver) const Divider(),
              if (vm.isDriver)
                _buildInfoRow(
                  vm.driverProfileExtension!.carTypeIcon(),
                  l10n.carType,
                  vm.driverProfileExtension!.carType(l10n),
                  theme,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.outline,
      ),
      onTap: onTap,
    );
  }
}
