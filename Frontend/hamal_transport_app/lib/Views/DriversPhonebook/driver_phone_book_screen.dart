import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/SharedWidgets/main_app_bar.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../ViewModels/driver_phone_book_view_model.dart';
import 'driver_list_view.dart';

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
      appBar: MainAppBar(title: l10n.drivers),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                /// Search & Filter
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: vm.updateQuery,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      cursorColor: Theme.of(context).colorScheme.primary,
                      decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: 56,
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        suffixIcon: SizedBox(
                          width: 56,
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => _showFilterOptions(context),
                          ),
                        ),
                        hintText: l10n.searchDriver,
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(120),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
