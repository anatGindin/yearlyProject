import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/logout_button.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  @override
  createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
      body: Consumer<UserProfileViewModel>(
        builder: (context, userProfileVM, _) {
          return Column(
            children: [
              Row(
                children: [
                  Text(l10n.name),
                  const Text(" : "),
                  Text(userProfileVM.name),
                ],
              ),
              Row(
                children: [
                  Text(l10n.phone),
                  const Text(" : "),
                  Text(userProfileVM.phone),
                ],
              ),
              Row(
                children: [
                  Text(l10n.role),
                  const Text(" : "),
                  Text(userProfileVM.role(l10n)),
                  Icon(userProfileVM.roleIcon()),
                ],
              ),
              _buildDriverInfo(context),
              const Spacer(),
              const LogoutButton(),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDriverInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProfileVM = context.watch<UserProfileViewModel>();

    if (userProfileVM.isDriver) {
      final driverExtension = userProfileVM.driverProfileExtension!;
      return Row(
        children: [
          Text(l10n.carType),
          const Text(" : "),
          Text(driverExtension.carType(l10n)),
          Icon(driverExtension.carTypeIcon()),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
