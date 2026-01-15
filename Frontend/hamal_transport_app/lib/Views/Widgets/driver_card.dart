import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/driver_page.dart';
import '../../Models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import 'driver_card_base.dart';

class DriverCard extends StatelessWidget {
  final UserProfile driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mutedColor = Theme.of(
      context,
    ).textTheme.bodyMedium!.color!.withValues(alpha: 0.6);

    return DriverCardBase(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DriverPage(driverProfile: driver)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 8),
              Text(driver.name, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          Row(
            children: [
              Icon(Icons.phone, color: mutedColor),
              const SizedBox(width: 8),
              Text(
                driver.phone,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: mutedColor),
              ),
            ],
          ),
          if (driver.driverProfile != null)
            Row(
              children: [
                Icon(
                  driver.driverProfile!.carType.getIcon(),
                  color: mutedColor,
                ),
                const SizedBox(width: 8),
                Text(
                  driver.driverProfile!.carType.displayName(l10n),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.italic,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
