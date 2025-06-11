import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyFileOp extends StatefulWidget {
  const MyFileOp({super.key});

  @override
  State<MyFileOp> createState() => _MyFileOpState();
}

class _MyFileOpState extends State<MyFileOp> {
  final _controller = TextEditingController();
  String _note = '';

  @override
  void initState() {
    super.initState();
    _readNote();
  }

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    print(dir);
    return dir.path;
  }

  Future<File> get _noteFile async {
    final path = await _localPath;

    return File('$path/note.txt');
  }

  Future<void> _writeNote(String content) async {
    final file = await _noteFile;
    await file.writeAsString(content);
    _readNote();
  }

  Future<void> _readNote() async {
    try {
      final file = await _noteFile;
      String content = await file.readAsString();
      setState(() => _note = content);
    } catch (e) {
      setState(() => _note = 'Belum ada catatan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File IO - Note")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Tulis Catatan"),
            ),
            ElevatedButton(
              onPressed: () => _writeNote(_controller.text),
              child: Text("Simpan"),
            ),
            SizedBox(height: 20),
            Text("Isi Catatan: $_note"),
          ],
        ),
      ),
    );
  }
}
