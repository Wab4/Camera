import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorAccelerometerScreen extends StatefulWidget {
  const SensorAccelerometerScreen({super.key});

  @override
  State<SensorAccelerometerScreen> createState() =>
      _SensorAccelerometerScreenState();
}

class _SensorAccelerometerScreenState extends State<SensorAccelerometerScreen> {
  double _accX = 0;
  double _accY = 0;
  double _accZ = 0;
  bool _isListening = false;

  StreamSubscription<AccelerometerEvent>? _subAcc;

  @override
  void dispose() {
    _subAcc?.cancel();
    super.dispose();
  }

  void _bacaSensor() {
    setState(() => _isListening = true);
    _subAcc = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 500),
    ).listen((event) {
      setState(() {
        _accX = event.x;
        _accY = event.y;
        _accZ = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Accelerometer"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sensors, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              "Data Akselerometer",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _SensorValueCard(label: "X", value: _accX),
            _SensorValueCard(label: "Y", value: _accY),
            _SensorValueCard(label: "Z", value: _accZ),
            const SizedBox(height: 32),
            if (!_isListening)
              const Text(
                "Tekan tombol di bawah untuk mulai membaca sensor.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isListening ? null : _bacaSensor,
              icon: const Icon(Icons.play_arrow),
              label: const Text("Mulai Baca Sensor"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorValueCard extends StatelessWidget {
  final String label;
  final double value;

  const _SensorValueCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        title: Text(
          "${value.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Sumbu $label", style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}