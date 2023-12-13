import 'dart:math' show asin, atan2, cos, sin, sqrt;
import 'package:latlong2/latlong.dart';

List<LatLng> getPointsBetween(LatLng latLng1, LatLng latLng2) {
  final lat1 = latLng1.latitude;
  final lon1 = latLng1.longitude;
  final lat2 = latLng2.latitude;
  final lon2 = latLng2.longitude;

  final distance = getDistance(lat1, lon1, lat2, lon2);
  final bearing = getBearing(lat1, lon1, lat2, lon2);
  final pointCount = (distance / 10).ceil() + 1;
  List<LatLng> points = [];

  for (var i = 0; i < pointCount; i++) {
    final fraction = i / (pointCount - 1);
    final pointDistance = fraction * distance;
    final point = getDestinationPoint(lat1, lon1, pointDistance, bearing);
    points.add(LatLng(point[0], point[1]));
  }

  return points;
}

double getDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const R = 6371000.0; // Earth radius in meters
  final phi1 = lat1 * (pi / 180);
  final phi2 = lat2 * (pi / 180);
  final deltaPhi = (lat2 - lat1) * (pi / 180);
  final deltaLambda = (lon2 - lon1) * (pi / 180);

  final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
      cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final distance = R * c;

  return distance;
}

double getBearing(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  final phi1 = lat1 * (pi / 180);
  final phi2 = lat2 * (pi / 180);
  final deltaLambda = (lon2 - lon1) * (pi / 180);

  final y = sin(deltaLambda) * cos(phi2);
  final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(deltaLambda);
  final bearing = atan2(y, x);

  return bearing;
}

List<double> getDestinationPoint(
  double lat1,
  double lon1,
  double distance,
  double bearing,
) {
  const R = 6371000.0; // Earth radius in meters
  final phi1 = lat1 * (pi / 180);
  final lambda1 = lon1 * (pi / 180);

  final phi2 = asin(sin(phi1) * cos(distance / R) +
      cos(phi1) * sin(distance / R) * cos(bearing));
  final lambda2 = lambda1 +
      atan2(sin(bearing) * sin(distance / R) * cos(phi1),
          cos(distance / R) - sin(phi1) * sin(phi2));

  final lat2 = phi2 * (180 / pi);
  final lon2 = lambda2 * (180 / pi);

  return [lat2, lon2];
}
