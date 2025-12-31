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
            Text(
              l10n.comments,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            if (missionViewModel.comments().isNotEmpty) ...[
              ...missionViewModel.comments().asMap().entries.map((entry) {
                final index = entry.key;
                final comment = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '• $comment',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () =>
                            _showEditCommentDialog(context, index, comment),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(l10n.deleteComment),
                              content: Text(
                                '${l10n.deleteCommentConfirmation}\n\n$comment',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text(l10n.cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    missionViewModel.deleteComment(index);
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text(l10n.confirm),
                                ),
                              ],
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                );
              }),
            ],
            const Divider(),
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

  void _showEditCommentDialog(
    BuildContext context,
    int index,
    String currentComment,
  ) {
    String newComment = currentComment;
    final missionVM = context.read<MissionViewModel>();
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.editCommentTitle),
          content: TextFormField(
            initialValue: currentComment,
            maxLines: 3,
            onChanged: (value) {
              newComment = value;
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
                if (newComment.trim().isNotEmpty) {
                  missionVM.editComment(index, newComment);
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
