import '../Models/mission.dart';
import '../features/Contact_card/model/contact.dart';
// mock data for contacts

/// Individual mock missions for reuse
final Mission mockMission1 = Mission.chosen(
  id: 'm1',
  location: 'בסיס חיל הים',
  description: 'חבילה שבירה',
  contact: Contact(fullName: 'שימחה ריף', phoneNumber: '+972-50-333-4444'),
  time: DateTime.now().add(const Duration(hours: 1)),
);

final Mission mockMission2 = Mission.chosen(
  id: 'm2',
  location: 'ירושלים - בן יהודה 12',
  description: 'מעטפה דחופה',
  contact: Contact(fullName: 'אבי רון', phoneNumber: '+972-52-9876543'),
  time: DateTime.now().add(const Duration(days: 1)),
);

final Mission mockMission3 = Mission.chosen(
  id: 'm3',
  location: 'חיפה - הנשיא 3',
  description: 'ארגז גדול, דורש עגלה',
  contact: Contact(fullName: 'גרי המבורגרי', phoneNumber: '+972-54-5555555'),
  time: DateTime.now().add(const Duration(hours: 6)),
);

final Mission mockMissionA1 = Mission(
  id: 'a1',
  location: 'רמת גן - ביאליק 5',
  description: 'חבילה קטנה',
  contact: Contact(fullName: 'יהודה המכבי', phoneNumber: '+972-50-1111111'),
  time: DateTime.now().add(const Duration(hours: 3)),
);

final Mission mockMissionA2 = Mission(
  id: 'a2',
  location: 'ראשון לציון - העצמאות 21',
  description: 'מסמכים',
  contact: Contact(
    fullName: 'בובספוג מכנסמרובע',
    phoneNumber: '+972-50-2222222',
  ),
  time: DateTime.now().add(const Duration(hours: 5)),
);

/// Mock data for active/upcoming missions
final List<Mission> sampleMissions = [mockMission1, mockMission2, mockMission3];

/// Mock data for available missions to pick (Open Tasks)
final List<Mission> availableMissions = [mockMissionA1, mockMissionA2];
