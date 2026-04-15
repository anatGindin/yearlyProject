import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hamal_transport_app/firebase_options.dart';
import 'package:hamal_transport_app/Services/firebase_test_service.dart';

void main() {
  // This line is required for integration tests that run on a real device/emulator
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Firebase Real Connection Test', () {
    testWidgets('Should connect to Firestore, add data, and read data', (
      WidgetTester tester,
    ) async {
      // 1. Initialize Firebase on the emulator
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 2. Instantiate our test service
      final testService = FirebaseTestService();

      // 3. Test writing to the real database
      bool writeSuccess = false;
      try {
        await testService.addTestData();
        writeSuccess = true;
      } catch (e) {
        fail('Exception thrown while writing to Firestore: $e');
      }
      expect(writeSuccess, true, reason: 'Writing to Firestore should succeed');

      // 4. Test reading from the real database
      bool readSuccess = false;
      try {
        await testService.readTestData();
        readSuccess = true;
      } catch (e) {
        fail('Exception thrown while reading from Firestore: $e');
      }
      expect(
        readSuccess,
        true,
        reason: 'Reading from Firestore should succeed',
      );
    });
  });
}
