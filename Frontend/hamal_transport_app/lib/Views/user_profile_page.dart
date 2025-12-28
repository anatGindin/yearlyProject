import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/user_avatar.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import 'UserMenu/profile_menu_view.dart';
import 'UserMenu/account_info_details_view.dart';
import 'UserMenu/edit_profile_view.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  @override
  createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page?.round() ?? 0;
      if (next != _currentPageIndex) {
        setState(() {
          _currentPageIndex = next;
        });
      }
    });
  }

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
      floatingActionButton: _currentPageIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                _pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.edit),
            )
          : null,
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
                      ProfileMenuView(
                        pageController: _pageController,
                        l10n: l10n,
                        theme: theme,
                      ),
                      // Page 1: Account Information details
                      AccountInfoDetailsView(
                        vm: userProfileVM,
                        pageController: _pageController,
                        l10n: l10n,
                        theme: theme,
                      ),
                      // Page 2: Edit Profile
                      EditProfileView(
                        vm: userProfileVM,
                        pageController: _pageController,
                        l10n: l10n,
                        theme: theme,
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
}
