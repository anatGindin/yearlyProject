import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../ViewModels/login_screen_view_model.dart';
import '../../Services/authentication_service.dart';
import '../role_based_routing.dart';
import 'signup_screen_view.dart';
import 'forgot_password_view.dart';
import '../Widgets/stage_header_background.dart';
import '../../ViewModels/user_profile_view_model.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginScreenViewModel(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: const _LoginContent(),
        ),
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
    final theme = Theme.of(context);

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
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
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
                        textDirection: TextDirection.ltr,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          prefixIcon: const Icon(Icons.email_outlined),
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
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: viewModel.rememberMe,
                            onChanged: viewModel.toggleRememberMe,
                          ),
                          Text(
                            l10n.rememberMe,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const ForgotPasswordView(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              ).whenComplete(() {
                                if (context.mounted) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(FocusNode());
                                }
                              });
                            },
                            child: Text(
                              l10n.forgotPassword,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
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
                                print(userProfile.name);
                                navigator.pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return ChangeNotifierProvider(
                                            create: (_) => UserProfileViewModel(
                                              userProfile,
                                            ),
                                            child: Builder(
                                              builder: (context) =>
                                                  getDestinationForRole(
                                                    userProfile.role,
                                                  ),
                                            ),
                                          );
                                        },
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }
                          },
                          style: FilledButton.styleFrom(
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
                            ).whenComplete(() {
                              _emailController.clear();
                              _passwordController.clear();
                              if (context.mounted) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(FocusNode());
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
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
