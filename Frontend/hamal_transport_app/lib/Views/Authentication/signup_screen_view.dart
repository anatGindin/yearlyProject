import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hamal_transport_app/Views/Widgets/stage_header_background.dart';
import '../../ViewModels/signup_screen_view_model.dart';
import '../../l10n/app_localizations.dart';
import '../../Services/authentication_service.dart';
import '../../Models/user_profile.dart';

class SignupScreenView extends StatelessWidget {
  const SignupScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupScreenViewModel(),
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: _SignupContent(),
      ),
    );
  }
}

class _SignupContent extends StatefulWidget {
  const _SignupContent();

  @override
  State<_SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<_SignupContent> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  UserRole? _selectedRole = UserRole.driver;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSignup(
    SignupScreenViewModel viewModel,
    AppLocalizations l10n,
  ) async {
    if (_formKey.currentState!.validate()) {
      final success = await viewModel.signup(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        role: _selectedRole!,
      );
      if (success && mounted) {
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n.signup),
              content: Text(l10n.signupSuccess),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close signup screen
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupScreenViewModel>();
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.error != null) {
        String message;
        switch (viewModel.error!) {
          case AuthenticationError.emailInvalid:
            message = l10n.invalidEmail;
          case AuthenticationError.passwordInvalid:
            message = l10n
                .passwordRules; // Or a specific error if validation failed on server side
          case AuthenticationError.networkRequestFailed:
            message = l10n.genericError;
          case AuthenticationError.emailAlreadyInUse:
            message = l10n.emailAlreadyInUse;
          case AuthenticationError.unknown:
          default:
            message = l10n.genericError;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    });

    return StageHeaderBackground(
      height: 160,
      title: Text(
        l10n.signup,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 16,
            top: 180,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                _CustomTextField(
                  controller: _nameController,
                  labelText: l10n.name,
                  validator: (value) => (value == null || value.isEmpty)
                      ? l10n.requiredField
                      : null,
                ),
                const SizedBox(height: 16),

                // Phone Field
                _CustomTextField(
                  controller: _phoneController,
                  labelText: l10n.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.isEmpty)
                      ? l10n.requiredField
                      : null,
                ),
                const SizedBox(height: 16),

                // Role Dropdown
                DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  decoration: InputDecoration(
                    labelText: l10n.selectRole,
                    border: const UnderlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: UserRole.driver,
                      child: Text(l10n.driver),
                    ),
                    DropdownMenuItem(
                      value: UserRole.logistics,
                      child: Text(l10n.logistics),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? l10n.roleRequired : null,
                ),
                const SizedBox(height: 16),

                // Email Field
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _emailController,
                  builder: (context, value, child) {
                    return _CustomTextField(
                      controller: _emailController,
                      labelText: l10n.email,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: viewModel.isEmailValid(value.text)
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      validator: (val) =>
                          (val == null || !viewModel.isEmailValid(val))
                          ? l10n.invalidEmail
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                _CustomTextField(
                  controller: _passwordController,
                  labelText: l10n.password,
                  obscureText: !viewModel.isPasswordVisible,
                  helperText: l10n.passwordRules,
                  helperMaxLines: 3,
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewModel.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: viewModel.togglePasswordVisibility,
                  ),
                  validator: (value) =>
                      (value == null || !viewModel.isPasswordValid(value))
                      ? l10n.passwordRules
                      : null,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                _CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: l10n.confirmPassword,
                  obscureText: !viewModel.isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewModel.isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: viewModel.toggleConfirmPasswordVisibility,
                  ),
                  validator: (value) => (value != _passwordController.text)
                      ? l10n.passwordMismatch
                      : null,
                ),
                const SizedBox(height: 40),

                _ActionButtons(
                  isLoading: viewModel.isLoading,
                  onSignup: () => _handleSignup(viewModel, l10n),
                  onLogin: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? helperText;
  final int helperMaxLines;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.helperText,
    this.helperMaxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const UnderlineInputBorder(),
        suffixIcon: suffixIcon,
        helperText: helperText,
        helperMaxLines: helperMaxLines,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSignup;
  final VoidCallback onLogin;

  const _ActionButtons({
    required this.isLoading,
    required this.onSignup,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        FilledButton(
          onPressed: onSignup,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF364678),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(l10n.signup),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: onLogin,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            foregroundColor: const Color(0xFF364678),
            side: const BorderSide(color: Color(0xFF364678)),
          ),
          child: Text(l10n.login),
        ),
      ],
    );
  }
}
