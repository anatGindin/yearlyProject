import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/my_missions_view_model.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'Widgets/mission_app_bar.dart';
import 'Widgets/mission_list_view.dart';
import 'Widgets/mission_fabs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/official_info.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Text(
                    l10n.activeMissions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  // Expanded mission list
                  Expanded(
                    child: Consumer<MyMissionsViewModel>(
                      builder: (context, myMissionsVM, _) {
                        return MissionListView(
                          missions: myMissionsVM.myMissions,
                        );
                      },
                    ),
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.callDesk),
        content: Text(l10n.callDeskMessage),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () async {
              final uri = Uri(scheme: 'tel', path: HAMAL_PHONE);
              await launchUrl(uri);
              Navigator.of(context).pop();
            },
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
