import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // singleton
  ConnectivityService._privateConstructor();
  static final ConnectivityService _instance =
      ConnectivityService._privateConstructor();
  factory ConnectivityService() => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _connectivityController =
      StreamController<ConnectivityResult>.broadcast();

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  void initialize() {
    // เช็คสถานะครั้งแรก
    _connectivity.checkConnectivity().then((result) {
      for (var res in result) {
        _connectivityController.add(res);
      }
    });

    // ฟังการเปลี่ยนแปลงสถานะ
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      for (var result in results) {
        _connectivityController.add(result);
      }
    });
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
    // return result != ConnectivityResult.none;
  }

  void dispose() {
    _connectivityController.close();
  }
}
