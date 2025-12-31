import 'package:flutter/material.dart';
import '../../../ViewModels/user_profile_view_model.dart';
import '../../../l10n/app_localizations.dart';
import '../Widgets/info_row.dart';

class AccountInfoDetailsView extends StatelessWidget {
  final UserProfileViewModel vm;
  final ValueChanged<int> onNavigate;
  final AppLocalizations l10n;
  final ThemeData theme;

  const AccountInfoDetailsView({
    super.key,
    required this.vm,
    required this.onNavigate,
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
                onPressed: () => onNavigate(0),
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
                child: Text(
                  vm.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(),
              InfoRow(
                icon: Icons.email,
                label: l10n.email,
                child: Text(
                  vm.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(),
              InfoRow(
                icon: Icons.phone,
                label: l10n.phone,
                child: Text(
                  vm.phone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(),
              InfoRow(
                icon: Icons.work,
                label: l10n.role,
                child: Text(
                  vm.role(l10n),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (vm.isDriver) const Divider(),
              if (vm.isDriver)
                InfoRow(
                  icon: vm.driverProfileExtension!.carTypeIcon(),
                  label: l10n.carType,
                  child: Text(
                    vm.driverProfileExtension!.carType(l10n),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
