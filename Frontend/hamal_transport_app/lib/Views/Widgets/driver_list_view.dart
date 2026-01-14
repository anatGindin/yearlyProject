import 'package:flutter/material.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import '../../Models/user_profile.dart';
import 'driver_card.dart';

class DriverListView extends StatelessWidget {
  final List<UserProfile> drivers;

  const DriverListView({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (drivers.isEmpty) {
      return Center(child: Text(l10n.noDrivers));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: drivers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return DriverCard(driver: drivers[index]);
      },
    );
  }
}
