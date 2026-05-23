import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:hamal_transport_app/Views/SharedWidgets/user_avatar.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import 'profile_menu_view.dart';
import 'account_info_details_view.dart';
import 'app_preferences_view.dart';
import 'edit_profile_view.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _currentPageIndex = 0;

  void _onNavigate(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      floatingActionButton: _currentPageIndex == 1
          ? FloatingActionButton(
              onPressed: () => _onNavigate(2),
              child: const Icon(Icons.edit),
            )
          : null,
      body: Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, _) {
          if (isLandscape) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(color: theme.colorScheme.surface),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.05, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                        child: _buildCurrentPage(userProfileVM, l10n, theme),
                      ),
                    ),
                  ),
                ),
                // Left Column (Avatar + Info)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UserAvatar(
                              name: userProfileVM.name,
                              radius: 45,
                              backgroundColor: theme.colorScheme.surface,
                              textStyle: theme.textTheme.headlineMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              userProfileVM.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userProfileVM.email,
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Portrait Stack
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  height: 350,
                  child: Stack(
                    children: [
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userProfileVM.email,
                              style: theme.textTheme.bodyMedium,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: _buildCurrentPage(userProfileVM, l10n, theme),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentPage(
    UserProfileViewModel userProfileVM,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    switch (_currentPageIndex) {
      case 0:
        return ProfileMenuView(
          key: const ValueKey(0),
          onNavigate: _onNavigate,
          l10n: l10n,
          theme: theme,
        );
      case 1:
        return AccountInfoDetailsView(
          key: const ValueKey(1),
          vm: userProfileVM,
          onNavigate: _onNavigate,
          l10n: l10n,
          theme: theme,
        );
      case 2:
        return EditProfileView(
          key: const ValueKey(2),
          vm: userProfileVM,
          onNavigate: _onNavigate,
          l10n: l10n,
          theme: theme,
        );
      case 3:
        return AppPreferencesView(
          key: const ValueKey(3),
          onNavigate: _onNavigate,
          l10n: l10n,
          theme: theme,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
