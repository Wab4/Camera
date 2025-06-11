import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorGyroscopeScreen extends StatefulWidget {
  const SensorGyroscopeScreen({super.key});

  @override
  State<SensorGyroscopeScreen> createState() => _SensorGyroscopeScreenState();
}

class _SensorGyroscopeScreenState extends State<SensorGyroscopeScreen> {
  StreamSubscription<GyroscopeEvent>? _subGyro;
  double _gyroX = 0;
  double _gyroY = 0;
  double _gyroZ = 0;
  bool _isListening = false;

  @override
  void dispose() {
    _subGyro?.cancel();
    super.dispose();
  }

  void _bacaSensor() {
    setState(() => _isListening = true);
    _subGyro = gyroscopeEventStream(
      samplingPeriod: const Duration(milliseconds: 500),
    ).listen((event) {
      setState(() {
        _gyroX = event.x;
        _gyroY = event.y;
        _gyroZ = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Gyroscope"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.threesixty, size: 64, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              "Data Gyroscope",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _SensorValueCard(label: "X (Roll)", value: _gyroX),
            _SensorValueCard(label: "Y (Pitch)", value: _gyroY),
            _SensorValueCard(label: "Z (Yaw)", value: _gyroZ),
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
            const SizedBox(height: 24),
            const Text(
              'Gerakkan perangkat untuk melihat perubahan nilai. '
              'Nilai positif menunjukkan rotasi berlawanan arah jarum jam '
              'di sekitar sumbu dari perspektif perangkat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
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
          child: Text(label[0], style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        title: Text(
          "${value.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}