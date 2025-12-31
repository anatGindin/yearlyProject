import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MissionCommentsTile extends StatelessWidget {
  final MissionViewModel missionViewModel;

  const MissionCommentsTile({super.key, required this.missionViewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (missionViewModel.comments().isNotEmpty) ...[
              Text(
                l10n.comments,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 8),
              ...missionViewModel.comments().asMap().entries.map((entry) {
                final index = entry.key;
                final comment = entry.value;
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(l10n.deleteComment),
                        content: Text(
                          '${l10n.deleteCommentConfirmation}\n\n$comment',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              missionViewModel.deleteComment(index);
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.confirm),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• $comment', textAlign: TextAlign.right),
                  ),
                );
              }),
            ],

            GestureDetector(
              onTap: () {
                _showAddCommentDialog(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.add_comment,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(l10n.addComment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCommentDialog(BuildContext context) {
    String comment = '';
    final missionVM = context.read<MissionViewModel>();
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.addComment),
          content: TextField(
            maxLines: 3,
            onChanged: (value) {
              comment = value;
            },
            decoration: InputDecoration(
              hintText: l10n.enterComment,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (comment.trim().isNotEmpty) {
                  missionVM.addComment(comment);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
