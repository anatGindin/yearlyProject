import 'package:flutter/material.dart';
import '../../../ViewModels/user_profile_view_model.dart';
import '../../../l10n/app_localizations.dart';
import '../Widgets/info_row.dart';

class AccountInfoDetailsView extends StatelessWidget {
  final UserProfileViewModel vm;
  final PageController pageController;
  final AppLocalizations l10n;
  final ThemeData theme;

  const AccountInfoDetailsView({
    super.key,
    required this.vm,
    required this.pageController,
    required this.l10n,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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
                  pageController.animateToPage(
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
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              InfoRow(
                icon: Icons.person,
                label: l10n.name,
                value: vm.name,
                theme: theme,
              ),
              const Divider(),
              InfoRow(
                icon: Icons.email,
                label: l10n.email,
                value: vm.email,
                theme: theme,
              ),
              const Divider(),
              InfoRow(
                icon: Icons.phone,
                label: l10n.phone,
                value: vm.phone,
                theme: theme,
              ),
              const Divider(),
              InfoRow(
                icon: Icons.work,
                label: l10n.role,
                value: vm.role(l10n),
                theme: theme,
              ),
              if (vm.isDriver) const Divider(),
              if (vm.isDriver)
                InfoRow(
                  icon: vm.driverProfileExtension!.carTypeIcon(),
                  label: l10n.carType,
                  value: vm.driverProfileExtension!.carType(l10n),
                  theme: theme,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
