import 'package:flutter/material.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../Models/user_profile.dart';
import '../../ViewModels/driver_phone_book_view_model.dart';
import '../SharedWidgets/DriverPage/driver_card.dart';

class DriverListView extends StatefulWidget {
  const DriverListView({super.key});

  @override
  State<DriverListView> createState() => _DriverListViewState();
}

class _DriverListViewState extends State<DriverListView> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, double> _sectionOffsets = {};

  static const double _sectionHeaderHeight = 40.0;
  static const double _cardHeight = 88.0;
  static const double _separatorHeight = 10.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _computeOffsets(Map<String, List<UserProfile>> grouped) {
    _sectionOffsets.clear();
    double offset = 0;
    for (final entry in grouped.entries) {
      _sectionOffsets[entry.key] = offset;
      offset += _sectionHeaderHeight;
      offset += entry.value.length * (_cardHeight + _separatorHeight);
    }
  }

  void _scrollToSection(String letter) {
    final target = _sectionOffsets[letter];
    if (target == null) return;
    _scrollController.animateTo(
      target.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverPhoneBookViewModel>();
    final grouped = vm.groupedDrivers;
    final l10n = AppLocalizations.of(context)!;

    if (grouped.isEmpty) {
      return Center(child: Text(l10n.noDrivers));
    }

    _computeOffsets(grouped);

    final letters = grouped.keys.toList();

    final List<Widget> items = [];
    for (final entry in grouped.entries) {
      items.add(_SectionHeader(letter: entry.key));
      for (int i = 0; i < entry.value.length; i++) {
        items.add(
          Padding(
            padding: EdgeInsets.only(
              bottom: i < entry.value.length - 1 ? _separatorHeight : 0,
            ),
            child: DriverCard(driver: entry.value[i]),
          ),
        );
      }
    }

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsetsDirectional.only(
            start: 8,
            end: 36,
            top: 8,
            bottom: 16,
          ),
          itemCount: items.length,
          itemBuilder: (_, index) => items[index],
        ),

        Positioned.directional(
          textDirection: Directionality.of(context),
          end: 0,
          top: 0,
          bottom: 0,
          child: _AlphabetSideBar(
            letters: letters,
            onLetterSelected: _scrollToSection,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String letter;
  const _SectionHeader({required this.letter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _DriverListViewState._sectionHeaderHeight,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.primary.withAlpha(60),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlphabetSideBar extends StatefulWidget {
  final List<String> letters;
  final void Function(String letter) onLetterSelected;

  const _AlphabetSideBar({
    required this.letters,
    required this.onLetterSelected,
  });

  @override
  State<_AlphabetSideBar> createState() => _AlphabetSideBarState();
}

class _AlphabetSideBarState extends State<_AlphabetSideBar> {
  String? _activeLetter;

  void _handleDrag(Offset localPosition, double totalHeight) {
    if (widget.letters.isEmpty) return;
    final fraction = (localPosition.dy / totalHeight).clamp(0.0, 1.0);
    final index = (fraction * widget.letters.length).floor().clamp(
      0,
      widget.letters.length - 1,
    );
    final letter = widget.letters[index];
    widget.onLetterSelected(letter);
    if (letter != _activeLetter) {
      setState(() => _activeLetter = letter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (d) => _handleDrag(d.localPosition, totalHeight),
          onPanUpdate: (d) => _handleDrag(d.localPosition, totalHeight),
          onPanEnd: (_) =>
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) setState(() => _activeLetter = null);
              }),
          onPanCancel: () => setState(() => _activeLetter = null),
          child: Container(
            width: 32,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.letters.map((letter) {
                final isActive = letter == _activeLetter;
                return Expanded(
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: isActive ? 24 : 18,
                      height: isActive ? 24 : 18,
                      decoration: isActive
                          ? BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: isActive ? 11 : 10,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(180),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
