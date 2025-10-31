// Stub for geolocator on web platform
// This file is used when dart.library.html is available (web platform)

class Position {
  final double latitude;
  final double longitude;
  
  Position({required this.latitude, required this.longitude});
}

enum LocationPermission {
  denied,
  deniedForever,
  allowed,
}

class Geolocator {
  static Future<bool> isLocationServiceEnabled() async {
    throw UnimplementedError('Geolocator is not supported on web');
  }
  
  static Future<LocationPermission> checkPermission() async {
    throw UnimplementedError('Geolocator is not supported on web');
  }
  
  static Future<LocationPermission> requestPermission() async {
    throw UnimplementedError('Geolocator is not supported on web');
  }
  
  static Future<Position> getCurrentPosition() async {
    throw UnimplementedError('Geolocator is not supported on web');
  }
}

