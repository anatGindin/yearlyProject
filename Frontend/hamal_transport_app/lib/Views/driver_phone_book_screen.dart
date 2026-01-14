import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/Widgets/list_action_button.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/driver_phone_book_view_model.dart';
import 'Widgets/driver_list_view.dart';

class DriverPhoneBookScreen extends StatelessWidget {
  const DriverPhoneBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverPhoneBookViewModel(),
      child: const _DriverPhoneBookView(),
    );
  }
}

class _DriverPhoneBookView extends StatelessWidget {
  const _DriverPhoneBookView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DriverPhoneBookViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.drivers),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListActionButton(
                  icon: Icons.filter_alt,
                  label: vm.getFilterBy(l10n, vm.filter),
                  onPressed: () => _showFilterOptions(context),
                  height: 0.1,
                  width: 0.1,
                ),
              ),
            ],
          ),

          /// Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: vm.updateQuery,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchDriver,
              ),
            ),
          ),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child:
                        /// List
                        DriverListView(drivers: vm.drivers),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final viewModel = context.read<DriverPhoneBookViewModel>();
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: viewModel.allowedFilterOptions
            .map(
              (option) => ListTile(
                title: Text(viewModel.getFilterBy(l10n, option)),
                onTap: () {
                  viewModel.filterBy(option);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
