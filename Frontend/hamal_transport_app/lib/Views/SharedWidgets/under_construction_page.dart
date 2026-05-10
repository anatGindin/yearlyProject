import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/Authentication/logout_button.dart';
import '../../l10n/app_localizations.dart';

class UnderConstructionPage extends StatelessWidget {
  const UnderConstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.construction,
                size: 100,
                color: Color(0xFF364678),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.underConstruction,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF364678),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.underConstructionMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, size: 40),
                color: const Color(0xFF364678),
              ),
              const SizedBox(height: 16),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
