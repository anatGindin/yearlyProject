import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileViewModel userProfileVM;
  const UserProfilePage({required this.userProfileVM, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
    );
  }
}
