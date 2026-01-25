import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/MissionsList/list_action_button.dart';
import 'package:hamal_transport_app/Models/missions_model.dart';
import 'package:provider/provider.dart';
import 'mission_list_view.dart';

class MissionsListBody extends StatelessWidget {
  const MissionsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    // We expect the MissionsListViewModel to be provided by the parent
    final viewModel = context.watch<MissionsListViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            left: 2.0,
            right: 2.0,
          ),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: viewModel.allowedFilterOptions.isNotEmpty
                                ? MediaQuery.of(context).size.width * 0.43
                                : MediaQuery.of(context).size.width * 0.8,
                            child: ListActionButton(
                              icon: Icons.sort,
                              label: viewModel.getSortBy(context),
                              onPressed: () => _showSortOptions(context),
                            ),
                          ),
                          if (viewModel.allowedFilterOptions.isNotEmpty)
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: ListActionButton(
                                icon: Icons.filter_alt,
                                label: viewModel.getFilterBy(context),
                                onPressed: () => _showFilterOptions(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MissionListView(missions: viewModel.missions),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final viewModel = context.read<MissionsListViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: viewModel.allowedSortOptions
            .map(
              (option) => ListTile(
                title: Text(option.getLabel(context)),
                onTap: () async {
                  if (option == SortBy.distanceToUserClosestFirst ||
                      option == SortBy.distanceToUserFurthestFirst) {
                    await viewModel.sortByGps(option);
                  } else {
                    viewModel.sortBy(option);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final viewModel = context.read<MissionsListViewModel>();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: viewModel.allowedFilterOptions
            .map(
              (option) => ListTile(
                title: Text(option.getLabel(context)),
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
