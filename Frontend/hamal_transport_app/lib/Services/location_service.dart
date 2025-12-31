import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal() {
    _initInitialLocation();
  }

  void _initInitialLocation() async {
    final hasPermission = await checkPermissions();
    if (hasPermission) {
      await getCurrentLocationOnce();
    }
  }

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();
  Stream<Position> get positionStream => _positionController.stream;

  StreamSubscription<Position>? _geolocatorSubscription;
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  Future<bool> checkPermissions() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return false;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return false;
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocationOnce() async {
    try {
      // 1. Try last known position first from cache
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        _currentPosition = lastKnown;
        _positionController.add(lastKnown);
        // We still trigger a fresh position fetch in the background but return fast
        Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
              ),
            )
            // silently update the current position and add it to the stream for next calls
            .then((fresh) {
              _currentPosition = fresh;
              _positionController.add(fresh);
            })
            .catchError((_) {});

        return lastKnown;
      }

      // 2. Otherwise get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _currentPosition = position;
      _positionController.add(position);
      return position;
    } catch (e) {
      print('Error getting current location once: $e');
      return null;
    }
  }

  void startLocationUpdates() {
    if (_geolocatorSubscription != null) return;

    // Get initial location
    getCurrentLocationOnce();

    // Listen for updates
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    _geolocatorSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _currentPosition = position;
            _positionController.add(position);
          },
          onError: (e) {
            print('Error in location stream: $e');
          },
        );
  }

  void stopLocationUpdates() {
    _geolocatorSubscription?.cancel();
    _geolocatorSubscription = null;
  }
}
