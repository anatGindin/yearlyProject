import 'package:flutter/material.dart';
import '../Models/mission.dart';
import '../l10n/app_localizations.dart';
import '../Constants/mock_data.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionScreen extends StatefulWidget {
  final Mission mission;
  const MissionScreen({required this.mission, super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.mission.status;
  }

  Future<void> _launchWaze(String address) async {
    final wazeUri = Uri.parse('waze://?q=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(wazeUri)) {
      await launchUrl(wazeUri);
      return;
    }
    final googleUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri);
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.cannotLaunchNavigation)));
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
      widget.mission.status = newStatus;
    });
    final label = _statusLabel(newStatus);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.statusUpdated}$label')));
  }

  void _takeMission() {
    final mission = widget.mission;
    if (availableMissions.contains(mission)) {
      setState(() {
        availableMissions.remove(mission);
        mission.status = 'chosen';
        sampleMissions.insert(0, mission);
        _status = mission.status;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.missionTaken)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.mission)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(mission.location, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24), textAlign: TextAlign.right),
          const SizedBox(height: 12),
          Text(mission.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const SizedBox(height: 16),
          Text('${AppLocalizations.of(context)!.contact}${mission.contact}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const SizedBox(height: 16),
          Text('${AppLocalizations.of(context)!.time}${mission.time}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16), textAlign: TextAlign.right),
          const SizedBox(height: 12),
          Text('${AppLocalizations.of(context)!.mission}: ${_statusLabel(_status)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showStatusOptions(),
                icon: const Icon(Icons.update),
                label: Text(AppLocalizations.of(context)!.updateStatus, style: const TextStyle(fontSize: 16)),
              ),
              ElevatedButton.icon(
                onPressed: () => _launchWaze(mission.location),
                icon: const Icon(Icons.navigation),
                label: Text(AppLocalizations.of(context)!.navigateWaze, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Show Take button when this mission is from the available tasks list
          if (availableMissions.contains(mission) && _status == 'available')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _takeMission,
                icon: const Icon(Icons.check),
                label: Text(AppLocalizations.of(context)!.takeMission, style: const TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
        ]),
      ),
    );
  }

  void _showStatusOptions() {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(title: Text(AppLocalizations.of(context)!.selectStatus)),
        ListTile(title: Text(AppLocalizations.of(context)!.chosen), onTap: () { Navigator.of(context).pop(); _updateStatus('chosen'); }),
        ListTile(title: Text(AppLocalizations.of(context)!.pickedUp), onTap: () { Navigator.of(context).pop(); _updateStatus('picked_up'); }),
        ListTile(title: Text(AppLocalizations.of(context)!.delivered), onTap: () { Navigator.of(context).pop(); _updateStatus('delivered'); }),
        ListTile(title: Text(AppLocalizations.of(context)!.cancelled), onTap: () { Navigator.of(context).pop(); _updateStatus('cancelled'); }),
      ]);
    });
  }

  // Map internal status codes to Hebrew labels for display
  String _statusLabel(String code) {
    switch (code) {
      case 'chosen':
        return AppLocalizations.of(context)!.chosen;
      case 'picked_up':
        return AppLocalizations.of(context)!.pickedUp;
      case 'delivered':
        return AppLocalizations.of(context)!.delivered;
      case 'cancelled':
        return AppLocalizations.of(context)!.cancelled;
      case 'available':
        return AppLocalizations.of(context)!.available;
      default:
        return code;
    }
  }
}
