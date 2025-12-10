import '../view_model/contact_vm.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final ContactViewModel vm;

  const ContactCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(vm.name, textAlign: TextAlign.center),
        subtitle: Text(
          vm.phone,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

class ContactCardActionable extends StatelessWidget {
  final ContactViewModel vm;
  final VoidCallback? onTap;

  const ContactCardActionable({super.key, required this.vm, this.onTap});

  Future<void> _defaultTap() async {
    final uri = Uri(scheme: 'tel', path: vm.phone);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => _defaultTap(),
      child: ContactCard(vm: vm),
    );
  }
}
