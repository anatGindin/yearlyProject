import '../Models/mission.dart';
import '../features/Contact_card/model/Contact.dart';
// mock data for contacts

/// Mock data for active/upcoming missions
final List<Mission> sampleMissions = [
  Mission(
    id: 'm1',
    location: 'בסיס חיל הים',
    description: 'חבילה שבירה',
    contact: Contact(fullName: 'שימחה ריף', phoneNumber: '+972-50-333-4444'),
    time: DateTime.now().add(const Duration(hours: 1)),
  ),
  Mission(
    id: 'm2',
    location: 'ירושלים - בן יהודה 12',
    description: 'מעטפה דחופה',
    contact: Contact(fullName: 'אבי רון', phoneNumber: '+972-52-9876543'),
    time: DateTime.now().add(const Duration(days: 1)),
  ),
  Mission(
    id: 'm3',
    location: 'חיפה - הנשיא 3',
    description: 'ארגז גדול, דורש עגלה',
    contact: Contact(fullName: 'גרי המבורגרי', phoneNumber: '+972-54-5555555'),
    time: DateTime.now().add(const Duration(hours: 6)),
  ),
];

/// Mock data for available missions to pick (Open Tasks)
final List<Mission> availableMissions = [
  Mission(
    id: 'a1',
    location: 'רמת גן - ביאליק 5',
    description: 'חבילה קטנה',
    contact: Contact(fullName: 'יהודה המכבי', phoneNumber: '+972-50-1111111'),
    time: DateTime.now().add(const Duration(hours: 3)),
  ),
  Mission(
    id: 'a2',
    location: 'ראשון לציון - העצמאות 21',
    description: 'מסמכים',
    contact: Contact(
      fullName: 'בובספוג מכנסמרובע',
      phoneNumber: '+972-50-2222222',
    ),
    time: DateTime.now().add(const Duration(hours: 5)),
  ),
];
