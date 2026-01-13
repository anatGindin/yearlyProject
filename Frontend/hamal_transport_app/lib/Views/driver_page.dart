import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/contact.dart';
import 'package:hamal_transport_app/ViewModels/driver_view_model.dart';
import 'package:hamal_transport_app/ViewModels/contact_vm.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';
import 'package:hamal_transport_app/Views/mission_screen.dart';
import 'package:hamal_transport_app/Views/contact_view.dart';
import 'package:provider/provider.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverPage),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DriverViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<DriverViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage!,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show page even if driver profile is null (just show missions)
          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDriverInfoCard(context, viewModel, theme, l10n),
                  const SizedBox(height: 24),
                  _buildMissionsSection(context, viewModel, theme, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverInfoCard(
    BuildContext context,
    DriverViewModel viewModel,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    viewModel.driverName.isNotEmpty
                        ? viewModel.driverName[0].toUpperCase()
                        : 'D',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.driverName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.driver,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(
              Icons.email,
              l10n.email,
              viewModel.driverEmail,
              theme,
            ),
            const SizedBox(height: 12),
            _buildPhoneRow(viewModel, theme, l10n),
            if (viewModel.carType != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.directions_car,
                l10n.carType,
                viewModel.carType!,
                theme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneRow(
    DriverViewModel viewModel,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    // Only show actionable phone if phone is available and not N/A
    if (viewModel.driverPhone == 'N/A' || viewModel.driverProfile == null) {
      return _buildInfoRow(
        Icons.phone,
        l10n.phone,
        viewModel.driverPhone,
        theme,
      );
    }

    // Create a contact with driver info for ContactInfoActionable
    final driverContact = Contact(
      fullName: viewModel.driverName,
      phoneNumber: viewModel.driverPhone,
    );
    final contactVM = ContactViewModel(driverContact);

    return Row(
      children: [
        Icon(Icons.phone, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.phone,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              ContactInfoActionable(vm: contactVM),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsSection(
    BuildContext context,
    DriverViewModel viewModel,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final missions = viewModel.driverMissions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.missions,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (missions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noMissions,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...missions.map(
            (mission) => _buildMissionCard(context, mission, theme, l10n),
          ),
      ],
    );
  }

  Widget _buildMissionCard(
    BuildContext context,
    Mission mission,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MissionScreen(mission: mission, isReadOnly: true),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      mission.description,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: mission.status.statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mission.status.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: mission.status.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildMissionLocationRow(
                Icons.location_on,
                l10n.source,
                mission.source.name,
                theme,
              ),
              const SizedBox(height: 8),
              _buildMissionLocationRow(
                Icons.flag,
                l10n.destination,
                mission.destination.name,
                theme,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${mission.time.day}/${mission.time.month}/${mission.time.year} ${mission.time.hour.toString().padLeft(2, '0')}:${mission.time.minute.toString().padLeft(2, '0')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              if (mission.comments.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.comment,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mission.comments.join(', '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionLocationRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}
