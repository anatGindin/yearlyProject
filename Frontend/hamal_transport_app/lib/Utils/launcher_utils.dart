import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  /// Launch Waze (or fallback to Google Maps) to the given address.
  /// Returns true if navigation launched, false otherwise.
  static Future<bool> launchNavigation(String address) async {
    // Try Waze first
    try {
      final wazeUri = Uri.parse('waze://?q=${Uri.encodeComponent(address)}');
      await launchUrl(wazeUri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      // Ignore and fallback to Google Maps
    }

    // Fallback to Google Maps
    try {
      final googleUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );
      await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Launch phone dialer with the given phone number.
  /// Returns true if the dialer was opened, false otherwise.
  static Future<bool> callPhoneNumber(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      return await launchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launch email client with the given email address.
  /// Returns true if the email client was opened, false otherwise.
  static Future<bool> launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    try {
      return await launchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launch the browser with the given URL.
  /// Returns true if the browser was opened, false otherwise.
  static Future<bool> launchBrowser(String url) async {
    final uri = Uri.parse(url);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }
}
