import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  String _label = "Belum ada data lokasi";

  Future<void> _bacaLokasi() async {
    try {
      bool isEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isEnabled) {
        setState(() => _label = "Lokasi tidak aktif. Aktifkan layanan lokasi.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() => _label = "Izin lokasi ditolak.");
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _label = "Izin lokasi ditolak secara permanen.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _label =
            "Lokasi Saat Ini:\nLatitude: ${position.latitude.toStringAsFixed(6)}\nLongitude: ${position.longitude.toStringAsFixed(6)}";
      });
    } catch (e) {
      setState(() => _label = "Gagal mengambil lokasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Membaca Lokasi GPS"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gps_fixed, size: 64, color: Colors.teal),
            const SizedBox(height: 24),
            Text(
              _label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _bacaLokasi,
              icon: const Icon(Icons.my_location),
              label: const Text("Ambil Lokasi Sekarang"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}