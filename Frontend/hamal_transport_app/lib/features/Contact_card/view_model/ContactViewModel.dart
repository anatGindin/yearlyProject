import 'package:flutter/foundation.dart';
import '../model/Contact.dart';

class ContactViewModel extends ChangeNotifier {
  final Contact contact;
  ContactViewModel(this.contact);

  String get name => contact.fullName;
  String get phone => contact.phoneNumber;
}
