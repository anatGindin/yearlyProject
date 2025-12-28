import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import '../../ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';
import '../../Services/authentication_service.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileViewModel vm;
  final ValueChanged<int> onNavigate;
  final AppLocalizations l10n;
  final ThemeData theme;

  const EditProfileView({
    super.key,
    required this.vm,
    required this.onNavigate,
    required this.l10n,
    required this.theme,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  CarType? _selectedCarType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vm.name);
    _phoneController = TextEditingController(text: widget.vm.phone);
    _selectedCarType = widget.vm.userProfile.driverProfile?.carType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _EditProfileHeader(
              l10n: widget.l10n,
              theme: widget.theme,
              onNavigate: widget.onNavigate,
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _EditProfileForm(
                    l10n: widget.l10n,
                    vm: widget.vm,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    selectedCarType: _selectedCarType,
                    onCarTypeChanged: (newValue) {
                      setState(() {
                        _selectedCarType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  _SaveButton(
                    l10n: widget.l10n,
                    vm: widget.vm,
                    formKey: _formKey,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    selectedCarType: _selectedCarType,
                    onNavigate: widget.onNavigate,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileHeader extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;
  final ValueChanged<int> onNavigate;

  const _EditProfileHeader({
    required this.l10n,
    required this.theme,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.close, textDirection: TextDirection.ltr),
              onPressed: () {
                FocusScope.of(context).unfocus();
                onNavigate(1);
              },
            ),
          ),
          Text(
            l10n.edit,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  final AppLocalizations l10n;
  final UserProfileViewModel vm;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final CarType? selectedCarType;
  final ValueChanged<CarType?> onCarTypeChanged;

  const _EditProfileForm({
    required this.l10n,
    required this.vm,
    required this.nameController,
    required this.phoneController,
    required this.selectedCarType,
    required this.onCarTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.name,
            prefixIcon: const Icon(
              Icons.person_outline,
              textDirection: TextDirection.ltr,
            ),
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          validator: (val) =>
              (val == null || val.isEmpty) ? l10n.requiredField : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: l10n.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              textDirection: TextDirection.ltr,
            ),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          textInputAction: vm.isDriver
              ? TextInputAction.next
              : TextInputAction.done,
          validator: (val) =>
              (val == null || !AuthenticationService.validateIsraeliPhone(val))
              ? l10n.invalidPhone
              : null,
        ),
        if (vm.isDriver) ...[
          const SizedBox(height: 20),
          DropdownButtonFormField<CarType>(
            initialValue: selectedCarType,
            decoration: InputDecoration(
              labelText: l10n.carType,
              prefixIcon: const Icon(
                Icons.directions_car_outlined,
                textDirection: TextDirection.ltr,
              ),
              border: const OutlineInputBorder(),
            ),
            items: CarType.values.map((CarType type) {
              return DropdownMenuItem<CarType>(
                value: type,
                child: Text(type.displayName(l10n)),
              );
            }).toList(),
            onChanged: onCarTypeChanged,
          ),
        ],
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final AppLocalizations l10n;
  final UserProfileViewModel vm;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final CarType? selectedCarType;
  final ValueChanged<int> onNavigate;

  const _SaveButton({
    required this.l10n,
    required this.vm,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.selectedCarType,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: vm.isUpdating
          ? const CircularProgressIndicator()
          : SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    await vm.updateProfile(
                      name: nameController.text,
                      phone: phoneController.text,
                      carType: selectedCarType,
                    );
                    onNavigate(1);
                  }
                },
                child: Text(l10n.save),
              ),
            ),
    );
  }
}
