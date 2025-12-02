import '../Models/mission.dart';

/// Mock data for active/upcoming missions
final List<Mission> sampleMissions = [
  Mission(
    id: 'm1',
    location: 'בסיס חיל הים',
    description: 'חבילה שבירה',
    contact: '+972-50-1234567',
    time: DateTime.now().add(const Duration(hours: 1)),
  ),
  Mission(
    id: 'm2',
    location: 'ירושלים - בן יהודה 12',
    description: 'מעטפה דחופה',
    contact: '+972-52-9876543',
    time: DateTime.now().add(const Duration(days: 1)),
  ),
  Mission(
    id: 'm3',
    location: 'חיפה - הנשיא 3',
    description: 'ארגז גדול, דורש עגלה',
    contact: '+972-54-5555555',
    time: DateTime.now().add(const Duration(hours: 6)),
  ),
];

/// Mock data for available missions to pick (Open Tasks)
final List<Mission> availableMissions = [
  Mission(
    id: 'a1',
    location: 'רמת גן - ביאליק 5',
    description: 'חבילה קטנה',
    contact: '+972-50-1111111',
    time: DateTime.now().add(const Duration(hours: 3)),
  ),
  Mission(
    id: 'a2',
    location: 'ראשון לציון - העצמאות 21',
    description: 'מסמכים',
    contact: '+972-50-2222222',
    time: DateTime.now().add(const Duration(hours: 5)),
  ),
];
