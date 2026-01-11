import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Models/mission.dart';
import '../Services/missions_repository.dart';
import '../l10n/app_localizations.dart';

class EditMissionScreen extends StatefulWidget {
  final Mission mission;

  const EditMissionScreen({required this.mission, super.key});

  @override
  State<EditMissionScreen> createState() => _EditMissionScreenState();
}

class _EditMissionScreenState extends State<EditMissionScreen> {
  late TextEditingController sourceCtrl;
  late TextEditingController destinationCtrl;
  late TextEditingController descriptionCtrl;
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    sourceCtrl = TextEditingController(text: widget.mission.source.name);
    destinationCtrl = TextEditingController(
      text: widget.mission.destination.name,
    );
    descriptionCtrl = TextEditingController(text: widget.mission.description);
    selectedTime = widget.mission.time;
  }

  @override
  void dispose() {
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text("haha")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: sourceCtrl,
              decoration: InputDecoration(
                labelText: l10n.sourceLocation,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(l10n.time),
              subtitle: Text(
                DateFormat.yMEd(l10n.localeName).add_Hm().format(selectedTime),
              ),
              onTap: _pickTime,
            ),

            const Spacer(),

            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
    );

    if (time == null) return;

    setState(() {
      selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveChanges() async {
    final repo = context.read<MissionsRepository>();

    // final updatedMission = widget.mission.copyWith(
    //   description: descriptionCtrl.text,
    //   time: selectedTime,
    // );

    // await repo.updateMission(updatedMission);

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
