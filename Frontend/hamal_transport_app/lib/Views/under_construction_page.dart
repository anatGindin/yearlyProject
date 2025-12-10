import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';
import 'Authentication/login_screen_view.dart';

class UnderConstructionPage extends StatelessWidget {
  const UnderConstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = AuthenticationService();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.underConstruction),
        centerTitle: true,
        backgroundColor: const Color(0xFF364678),
        foregroundColor: Colors.white,
      ),
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
              FilledButton.icon(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginScreenView(),
                        transitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF364678),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
