// models/user_model.dart
class UserModel {
  final String id;
  final String phone;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String role;
  final double rating;
  final int totalRides;

  UserModel({
    required this.id,
    required this.phone,
    this.fullName,
    this.email,
    this.avatarUrl,
    required this.role,
    this.rating = 0,
    this.totalRides = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        phone: json['phone'] ?? '',
        fullName: json['full_name'],
        email: json['email'],
        avatarUrl: json['avatar_url'],
        role: json['role'] ?? 'rider',
        rating: (json['rating'] ?? 0).toDouble(),
        totalRides: json['total_rides'] ?? 0,
      );

  bool get isDriver => role == 'driver';
  String get displayName => fullName ?? phone;
}

// models/ride_model.dart
class RideModel {
  final String id;
  final String riderId;
  final String? driverId;
  final double pickupLat;
  final double pickupLng;
  final String pickupAddress;
  final double dropoffLat;
  final double dropoffLng;
  final String dropoffAddress;
  final String status;
  final String rideType;
  final double fare;
  final double distanceKm;
  final int? durationMinutes;
  final DriverModel? driver;
  final DateTime createdAt;
  // Rider info (populated from nested rider object when available)
  final String? riderName;
  final double riderRating;

  RideModel({
    required this.id,
    required this.riderId,
    this.driverId,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.dropoffAddress,
    required this.status,
    required this.rideType,
    required this.fare,
    required this.distanceKm,
    this.durationMinutes,
    this.driver,
    required this.createdAt,
    this.riderName,
    this.riderRating = 5.0,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    // The backend may embed the rider object
    final riderJson = json['rider'] as Map<String, dynamic>?;
    return RideModel(
      id: json['id'] ?? '',
      riderId: json['rider_id'] ?? '',
      driverId: json['driver_id'],
      pickupLat: (json['pickup_lat'] ?? 0).toDouble(),
      pickupLng: (json['pickup_lng'] ?? 0).toDouble(),
      pickupAddress: json['pickup_address'] ?? '',
      dropoffLat: (json['dropoff_lat'] ?? 0).toDouble(),
      dropoffLng: (json['dropoff_lng'] ?? 0).toDouble(),
      dropoffAddress: json['dropoff_address'] ?? '',
      status: json['status'] ?? 'searching',
      rideType: json['ride_type'] ?? 'economy',
      fare: (json['fare'] ?? 0).toDouble(),
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      durationMinutes: json['duration_minutes'],
      driver: json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      riderName: riderJson?['full_name'] as String?,
      riderRating: (riderJson?['rating'] ?? 5.0).toDouble(),
    );
  }

  bool get isActive => [
        'searching',
        'accepted',
        'driver_arriving',
        'driver_arrived',
        'in_progress',
      ].contains(status);
}

// models/driver_model.dart
class DriverModel {
  final String id;
  final String userId;
  final UserModel? user;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final String licensePlate;
  final String status;
  final double rating;
  final int totalTrips;
  final double? currentLat;
  final double? currentLng;

  DriverModel({
    required this.id,
    required this.userId,
    this.user,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licensePlate,
    required this.status,
    this.rating = 0,
    this.totalTrips = 0,
    this.currentLat,
    this.currentLng,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json['id'] ?? '',
        userId: json['user_id'] ?? '',
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        vehicleMake: json['vehicle_make'] ?? '',
        vehicleModel: json['vehicle_model'] ?? '',
        vehicleColor: json['vehicle_color'] ?? '',
        licensePlate: json['license_plate'] ?? '',
        status: json['status'] ?? 'offline',
        rating: (json['rating'] ?? 0).toDouble(),
        totalTrips: json['total_trips'] ?? 0,
        currentLat: json['current_lat']?.toDouble(),
        currentLng: json['current_lng']?.toDouble(),
      );

  String get vehicleInfo => '$vehicleColor $vehicleMake $vehicleModel';
  String get displayName => user?.fullName ?? 'Driver';
}