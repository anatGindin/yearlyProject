import '../../../ViewModels/contact_vm.dart';
import 'package:flutter/material.dart';
import '../../../Utils/launcher_utils.dart';

class ContactInfoActionable extends StatelessWidget {
  final ContactViewModel vm;
  final VoidCallback? onPressed;

  const ContactInfoActionable({super.key, required this.vm, this.onPressed});

  Future<void> _defaultTap() async {
    await LauncherUtils.callPhoneNumber(vm.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            vm.name,
            textAlign: TextAlign.start,
            softWrap: true,
            textScaler: const TextScaler.linear(1.2),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onPressed ?? () => _defaultTap(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(
              177,
              228,
              162,
              0.7019607843137254,
            ),
            elevation: 2,
            shadowColor: const Color.fromRGBO(
              209,
              255,
              194,
              0.7019607843137254,
            ),
          ),
          icon: const Icon(Icons.phone, size: 28, color: Colors.white),
          iconAlignment: IconAlignment.end,
          label: Text(
            vm.phone,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            textScaler: const TextScaler.linear(1.0),
          ),
        ),
      ],
    );
  }
}
