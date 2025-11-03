import 'dart:async';
import 'dart:io';

/// Enum representing connectivity status.
enum ConnectivityResult { wifi, mobile, none }

/// A service to check network connectivity.
class ConnectivityService {
  StreamSubscription? _subscription;

  /// Check current connectivity status.
  Future<ConnectivityResult> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return ConnectivityResult
            .wifi; // Simplified, assuming wifi if connected
      }
    } on SocketException catch (_) {
      return ConnectivityResult.none;
    }
    return ConnectivityResult.none;
  }

  /// Listen to connectivity changes.
  Stream<ConnectivityResult> get onConnectivityChanged {
    // For simplicity, return a stream that periodically checks connectivity
    return Stream.periodic(
      const Duration(seconds: 5),
    ).asyncMap((_) => checkConnectivity());
  }

  /// Dispose of the service.
  void dispose() {
    _subscription?.cancel();
  }
}
