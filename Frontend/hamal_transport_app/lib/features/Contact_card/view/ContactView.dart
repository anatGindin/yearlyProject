import '../view_model/ContactViewModel.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final ContactViewModel vm;

  const ContactCard({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(vm.name), subtitle: Text(vm.phone)),
    );
  }
}
