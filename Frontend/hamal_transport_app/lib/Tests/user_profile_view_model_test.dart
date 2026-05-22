import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/Models/contact.dart';
import 'package:hamal_transport_app/Models/location.dart';
import 'package:hamal_transport_app/Models/mission.dart';
import 'package:hamal_transport_app/Models/mission_list_type.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';
import 'package:hamal_transport_app/Services/backend_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';

void main() {
  late FakeAuthenticationService authService;
  late MissionsRepository missionsRepository;
  late UserProfileViewModel viewModel;

  setUp(() {
    MissionsRepository.reset();
    authService = FakeAuthenticationService();
    missionsRepository = MissionsRepository(
      authService: authService,
      backendService: BackendService(authService: authService),
      missions: [_mission()],
    );
    viewModel = UserProfileViewModel(
      UserProfile(
        uid: 'user-1',
        email: 'driver@test.com',
        name: 'Driver',
        phone: '0500000000',
        role: UserRole.driver,
      ),
      authService: authService,
      missionsRepository: missionsRepository,
    );
  });

  tearDown(MissionsRepository.reset);

  test(
    'logout clears missions and signs out without notifying listeners',
    () async {
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      expect(
        missionsRepository.getMissions(MissionListType.allMissions),
        isNotEmpty,
      );

      await viewModel.logOut();

      expect(authService.signOutCalled, isTrue);
      expect(
        missionsRepository.getMissions(MissionListType.allMissions),
        isEmpty,
      );
      expect(notificationCount, 0);
    },
  );
}

Mission _mission() {
  return Mission(
    id: 'mission-1',
    source: Location(name: 'Source', latitude: 0, longitude: 0),
    destination: Location(name: 'Destination', latitude: 1, longitude: 1),
    description: 'Test mission',
    sourceContact: Contact(fullName: 'Source Contact', phoneNumber: '111'),
    destinationContact: Contact(
      fullName: 'Destination Contact',
      phoneNumber: '222',
    ),
    time: DateTime(2024),
    comments: const [],
    carType: CarType.private,
  );
}
