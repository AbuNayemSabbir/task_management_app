import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todo_app/view/helper_widget/helper_utills.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<AccelerometerEvent> accelerometerData = [];
  List<_GyroData> gyroData = [];
  final double threshold = 2;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _startAccelerometerStream();
    _startLocationStream();
    _startGyroscopeStream();
  }
  void _startGyroscopeStream() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (mounted) {
        setState(() {
          gyroData.add(_GyroData(gyroData.length, event.x, event.y, event.z));
          _checkForHighMovement(event.x, event.y, event.z);
        });
      }
    });
  }
  void _startAccelerometerStream() {
    _accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          accelerometerData.add(event);
        });
      }
    });
  }

  void _startLocationStream() async {
    geo.LocationPermission permission = await geo.Geolocator.requestPermission();
    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      return;
    }
  }

  // Check for high movement on two axes at the same time
  void _checkForHighMovement(double xAxis, double yAxis, double zAxis) {
    if ((xAxis.abs() > threshold && yAxis.abs() > threshold) ||
        (xAxis.abs() > threshold && zAxis.abs() > threshold) ||
        (yAxis.abs() > threshold && zAxis.abs() > threshold)) {
      _showAlert();
    }
  }

  // Show alert when high movement is detected
  void _showAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ALERT: High movement detected!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );

  }
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Graph Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Gyroscope Data
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: customBoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Gyro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Divider(color: Colors.grey[300]),
                      // Use Flexible to fit charts in smaller views
                      SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Meeting'),
                          legend: const Legend(isVisible: true),
                          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Samples')),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'Gyro data (rad/s)'),
                            minimum: -0.2, maximum: 0.3,
                          ),
                          series: <CartesianSeries>[
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.xAxis,
                              name: 'Gyro X',
                              color: Colors.blue,
                            ),
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.yAxis,
                              name: 'Gyro Y',
                              color: Colors.green,
                            ),
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.zAxis,
                              name: 'Gyro Z',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          title: const ChartTitle(text: 'Walking'),
                          legend: const Legend(isVisible: true),
                          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Samples')),
                          primaryYAxis: const NumericAxis(
                            title: AxisTitle(text: 'Gyro data (rad/s)'),
                            minimum: -4, maximum: 4,
                          ),
                          series: <CartesianSeries>[
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.xAxis,
                              name: 'Gyro X',
                              color: Colors.blue,
                            ),
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.yAxis,
                              name: 'Gyro Y',
                              color: Colors.green,
                            ),
                            LineSeries<_GyroData, int>(
                              dataSource: gyroData,
                              xValueMapper: (_GyroData data, _) => data.sampleIndex,
                              yValueMapper: (_GyroData data, _) => data.zAxis,
                              name: 'Gyro Z',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Accelerometer Data
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: customBoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Accelerometer Sensor Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Divider(color: Colors.grey[300]),
                      SizedBox(
                        height: 120,
                        child: SfCartesianChart(
                          series: <CartesianSeries>[
                            LineSeries<AccelerometerEvent, int>(
                              dataSource: accelerometerData,
                              xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data),
                              yValueMapper: (AccelerometerEvent data, _) => data.x,
                              name: 'X',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: SfCartesianChart(
                          series: <CartesianSeries>[
                            LineSeries<AccelerometerEvent, int>(
                              dataSource: accelerometerData,
                              xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data),
                              yValueMapper: (AccelerometerEvent data, _) => data.y,
                              name: 'Y',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: SfCartesianChart(
                          series: <CartesianSeries>[
                            LineSeries<AccelerometerEvent, int>(
                              dataSource: accelerometerData,
                              xValueMapper: (AccelerometerEvent data, _) => accelerometerData.indexOf(data),
                              yValueMapper: (AccelerometerEvent data, _) => data.z,
                              name: 'Z',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GyroData {
  final int sampleIndex;
  final double xAxis;
  final double yAxis;
  final double zAxis;

  _GyroData(this.sampleIndex, this.xAxis, this.yAxis, this.zAxis);
}
