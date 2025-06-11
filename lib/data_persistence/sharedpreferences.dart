import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences extends StatefulWidget {
  const MySharedPreferences({super.key});

  @override
  State<MySharedPreferences> createState() => _MySharedPreferencesState();
}

class _MySharedPreferencesState extends State<MySharedPreferences> {
  final _controller = TextEditingController();
  String? _savedName = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Preferences")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Masukkan Nama'),
            ),
            ElevatedButton(onPressed: _saveName, child: Text("Simpan")),
            SizedBox(height: 20),
            Text("Nama Tersimpan: $_savedName"),
          ],
        ),
      ),
    );
  }
}
