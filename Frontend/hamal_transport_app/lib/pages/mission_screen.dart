import 'package:flutter/material.dart';
import '../models/mission.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('לא ניתן לפתוח אפליקציית הניווט')));
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
      widget.mission.status = newStatus;
    });
    final label = _statusLabel(newStatus);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('סטטוס עודכן ל: $label')));
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('המשימה נבחרה')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    return Scaffold(
      appBar: AppBar(title: const Text('משימה')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(mission.location, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24), textAlign: TextAlign.right),
          const SizedBox(height: 12),
          Text(mission.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const SizedBox(height: 16),
          Text('איש קשר: ${mission.contact}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const SizedBox(height: 16),
          Text('תזמון: ${mission.time}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16), textAlign: TextAlign.right),
          const SizedBox(height: 12),
          Text('סטטוס: ${_statusLabel(_status)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18), textAlign: TextAlign.right),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showStatusOptions(),
                icon: const Icon(Icons.update),
                label: const Text('עדכן סטטוס', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton.icon(
                onPressed: () => _launchWaze(mission.location),
                icon: const Icon(Icons.navigation),
                label: const Text('נווט ב-Waze', style: TextStyle(fontSize: 16)),
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
                label: const Text('קח משימה', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
        ]),
      ),
    );
  }

  void _showStatusOptions() {
    showModalBottomSheet<void>(context: context, builder: (context) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        const ListTile(title: Text('בחר סטטוס')),
        ListTile(title: const Text('נבחר'), onTap: () { Navigator.of(context).pop(); _updateStatus('chosen'); }),
        ListTile(title: const Text('נאסף'), onTap: () { Navigator.of(context).pop(); _updateStatus('picked_up'); }),
        ListTile(title: const Text('נמסר'), onTap: () { Navigator.of(context).pop(); _updateStatus('delivered'); }),
        ListTile(title: const Text('בוטל'), onTap: () { Navigator.of(context).pop(); _updateStatus('cancelled'); }),
      ]);
    });
  }

  // Map internal status codes to Hebrew labels for display
  String _statusLabel(String code) {
    switch (code) {
      case 'chosen':
        return 'נבחר';
      case 'picked_up':
        return 'נאסף';
      case 'delivered':
        return 'נמסר';
      case 'cancelled':
        return 'בוטל';
      case 'available':
        return 'זמין';
      default:
        return code;
    }
  }
}
