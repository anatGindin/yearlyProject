import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';
import '../Constants/mock_data.dart';
import 'Widgets/mission_app_bar.dart';
import 'Widgets/mission_list_view.dart';
import 'Widgets/mission_fabs.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MissionAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  if (AuthenticationService().currentUser?.email != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Debug: ${AuthenticationService().currentUser!.email}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  Text(
                    AppLocalizations.of(context)!.activeMissions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  // Expanded mission list
                  Expanded(child: MissionListView(missions: sampleMissions)),
                  const SizedBox(
                    height: 72,
                  ), // spacing to keep list above buttons
                ],
              ),
              MissionFABs(onCallDesk: () => _callHamalDesk(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _callHamalDesk(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.callDesk),
        content: Text(AppLocalizations.of(context)!.callDeskMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }
}
