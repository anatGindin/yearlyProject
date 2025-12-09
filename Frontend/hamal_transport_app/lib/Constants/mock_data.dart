import '../Models/mission.dart';

/// Individual mock missions for reuse
final Mission mockMission1 = Mission(
  id: 'm1',
  location: 'בסיס חיל הים',
  description: 'חבילה שבירה',
  contact: '+972-50-1234567',
  time: DateTime.now().add(const Duration(hours: 1)),
);

final Mission mockMission2 = Mission(
  id: 'm2',
  location: 'ירושלים - בן יהודה 12',
  description: 'מעטפה דחופה',
  contact: '+972-52-9876543',
  time: DateTime.now().add(const Duration(days: 1)),
);

final Mission mockMission3 = Mission(
  id: 'm3',
  location: 'חיפה - הנשיא 3',
  description: 'ארגז גדול, דורש עגלה',
  contact: '+972-54-5555555',
  time: DateTime.now().add(const Duration(hours: 6)),
);

final Mission mockMissionA1 = Mission(
  id: 'a1',
  location: 'רמת גן - ביאליק 5',
  description: 'חבילה קטנה',
  contact: '+972-50-1111111',
  time: DateTime.now().add(const Duration(hours: 3)),
);

final Mission mockMissionA2 = Mission(
  id: 'a2',
  location: 'ראשון לציון - העצמאות 21',
  description: 'מסמכים',
  contact: '+972-50-2222222',
  time: DateTime.now().add(const Duration(hours: 5)),
);

/// Mock data for active/upcoming missions
final List<Mission> sampleMissions = [mockMission1, mockMission2, mockMission3];

/// Mock data for available missions to pick (Open Tasks)
final List<Mission> availableMissions = [mockMissionA1, mockMissionA2];
