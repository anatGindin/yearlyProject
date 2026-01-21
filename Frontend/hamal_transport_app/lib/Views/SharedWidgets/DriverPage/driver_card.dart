import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/DriversPhonebook/driver_page.dart';
import '../../../Models/user_profile.dart';
import 'driver_card_base.dart';

class DriverCard extends StatelessWidget {
  final UserProfile driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return DriverCardBase(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DriverPage(driverProfile: driver)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(driver.name, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
