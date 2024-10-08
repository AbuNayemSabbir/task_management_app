import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo; // Alias to avoid conflicts
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<AccelerometerEvent> accelerometerData = [];
  List<geo.Position> locationData = [];

  @override
  void initState() {
    super.initState();
    _startAccelerometerStream();
    _startLocationStream();
  }

  void _startAccelerometerStream() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerData.add(event);
      });
    });
  }

  void _startLocationStream() async {
    geo.LocationPermission permission = await geo.Geolocator.requestPermission();
    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      return;
    }

    geo.Geolocator.getPositionStream().listen((geo.Position position) {
      setState(() {
        locationData.add(position);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Page'),
      ),
      body: Column(
        children: [
          // Accelerometer Graph
          SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(text: 'Sample'),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Accelerometer Sensor Data'),
            ),
            series: <CartesianSeries>[
              LineSeries<AccelerometerEvent, num>(
                dataSource: accelerometerData,
                xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data), // Sample index
                yValueMapper: (AccelerometerEvent data, _) => data.x,
                name: 'X',
                color: Colors.red,
              ),
              LineSeries<AccelerometerEvent, num>(
                dataSource: accelerometerData,
                xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data),
                yValueMapper: (AccelerometerEvent data, _) => data.y,
                name: 'Y',
                color: Colors.green,
              ),
              LineSeries<AccelerometerEvent, num>(
                dataSource: accelerometerData,
                xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data),
                yValueMapper: (AccelerometerEvent data, _) => data.z,
                name: 'Z',
                color: Colors.blue,
              ),
            ],
          ),
          // Location Graph
          SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(text: 'Sample'),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Location Data'),
            ),
            series: <CartesianSeries>[
              LineSeries<geo.Position, num>(
                dataSource: locationData,
                xValueMapper: (geo.Position data, _) => locationData.indexOf(data), // Sample index
                yValueMapper: (geo.Position data, _) => data.latitude,
                name: 'Latitude',
                color: Colors.red,
              ),
              LineSeries<geo.Position, num>(
                dataSource: locationData,
                xValueMapper: (geo.Position data, _) => locationData.indexOf(data),
                yValueMapper: (geo.Position data, _) => data.longitude,
                name: 'Longitude',
                color: Colors.green,
              ),
              LineSeries<geo.Position, num>(
                dataSource: locationData,
                xValueMapper: (geo.Position data, _) => locationData.indexOf(data),
                yValueMapper: (geo.Position data, _) => data.altitude,
                name: 'Altitude',
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
