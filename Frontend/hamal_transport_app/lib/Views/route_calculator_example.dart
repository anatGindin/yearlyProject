import 'package:flutter/material.dart';
import '../Services/routing_service.dart';

/// Example widget demonstrating how to use the RoutingService
class RouteCalculatorExample extends StatefulWidget {
  const RouteCalculatorExample({super.key});

  @override
  State<RouteCalculatorExample> createState() => _RouteCalculatorExampleState();
}

class _RouteCalculatorExampleState extends State<RouteCalculatorExample> {
  RouteInfo? _routeInfo;
  bool _isLoading = false;
  String? _errorMessage;

  // Example coordinates (Tel Aviv to Jerusalem)
  final double _startLat = 32.0853; // Tel Aviv
  final double _startLon = 34.7818;
  final double _endLat = 31.7683; // Jerusalem
  final double _endLon = 35.2137;

  Future<void> _calculateRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _routeInfo = null;
    });

    try {
      final routeInfo = await RoutingService.getRouteInfo(
        startLat: _startLat,
        startLon: _startLon,
        endLat: _endLat,
        endLon: _endLon,
        profile: 'car', // Options: 'car', 'bike', 'foot'
      );

      setState(() {
        _routeInfo = routeInfo;
        _isLoading = false;
        if (routeInfo == null) {
          _errorMessage = 'Could not calculate route';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Calculator Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calculate route from Tel Aviv to Jerusalem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Start: $_startLat, $_startLon'),
            Text('End: $_endLat, $_endLon'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculateRoute,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Calculate Route'),
            ),
            const SizedBox(height: 24),
            if (_routeInfo != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Route Information:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Distance', _routeInfo!.formattedDistance),
                      _buildInfoRow('Duration', _routeInfo!.formattedDuration),
                      const Divider(),
                      _buildInfoRow(
                        'Distance (m)',
                        _routeInfo!.distanceInMeters.toStringAsFixed(0),
                      ),
                      _buildInfoRow(
                        'Duration (min)',
                        _routeInfo!.durationMinutes.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
