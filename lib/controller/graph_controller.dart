import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:sensors_plus/sensors_plus.dart';

class GraphController extends GetxController {
  var locationData = <geo.Position>[].obs;
  var accelerometerData = <AccelerometerEvent>[].obs;
  var isLoading=false.obs;

  // Example method to update data
  void updateLocationData(geo.Position newData) {
    locationData.add(newData); // This will notify listeners
  }

  void updateAccelerometerData(AccelerometerEvent newData) {
    accelerometerData.add(newData); // This will notify listeners
  }

  void startAccelerometerStream() {
    accelerometerEventStream().listen((AccelerometerEvent event) {
      accelerometerData.add(event);
    });
  }

  Future<void> startLocationStream() async {
    geo.LocationPermission permission = await geo.Geolocator.requestPermission();
    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      Get.back();
      return;
    }

    geo.Geolocator.getPositionStream().listen((geo.Position position) {
      locationData.add(position);
    });
  }
}
