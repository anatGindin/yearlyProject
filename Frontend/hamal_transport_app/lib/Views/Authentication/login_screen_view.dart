import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../ViewModels/login_screen_view_model.dart';
import '../../Services/authentication_service.dart';
import '../role_based_routing.dart';
import 'signup_screen_view.dart';
import '../Widgets/stage_header_background.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginScreenViewModel(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginScreenViewModel>();
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.error != null) {
        String message;
        switch (viewModel.error!) {
          case AuthenticationError.emailInvalid:
            message = l10n.invalidEmail;
          case AuthenticationError.passwordInvalid:
            message = l10n.wrongPassword;
          case AuthenticationError.wrongPassword:
            message = l10n.wrongPassword;
          case AuthenticationError.networkRequestFailed:
            message = l10n.genericError;
          case AuthenticationError.emailAlreadyInUse:
            message = l10n.signupError;
          case AuthenticationError.unknown:
            message = l10n.genericError;
          default:
            message = l10n.genericError;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    });

    return StageHeaderBackground(
      height: 320,
      title: Image.asset('Resources/Images/logo2.png', height: 180),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 16,
              top: 320,
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              viewModel.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: viewModel.togglePasswordVisibility,
                          ),
                        ),
                        obscureText: !viewModel.isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.requiredField;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // Remember Me
                      Row(
                        children: [
                          Checkbox(
                            value: viewModel.rememberMe,
                            activeColor: const Color(0xFF364678),
                            onChanged: viewModel.toggleRememberMe,
                          ),
                          Text(l10n.rememberMe),
                        ],
                      ),

                      // const SizedBox(height: 24), // Replaced 40 with 24 + checkbox height balance
                      if (viewModel.isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final navigator = Navigator.of(context);
                              final userProfile = await viewModel.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (userProfile != null && mounted) {
                                navigator.pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => getDestinationForRole(
                                          userProfile.role,
                                        ),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF364678),
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: Text(l10n.login),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SignupScreenView(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: const Color(0xFF364678),
                            side: const BorderSide(color: Color(0xFF364678)),
                          ),
                          child: Text(l10n.signup),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
