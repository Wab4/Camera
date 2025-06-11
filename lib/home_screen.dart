import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'gps_and_map_screen.dart';
import 'sensor/sensor_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alat"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Fitur Aplikasi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24),
            _FeatureCard(
              icon: Icons.map,
              title: "GPS dan Peta",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GpsAndMapScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _FeatureCard(
              icon: Icons.camera_alt,
              title: "Kamera",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CameraScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _FeatureCard(
              icon: Icons.sensors,
              title: "Sensor",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SensorHomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
