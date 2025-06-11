import 'data_persistence/sqlite_example.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PBM 2025',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginScreen(), // Ubah menjadi LoginScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

// ---------------- LOGIN SCREEN ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';

  void _login() {
    String user = _usernameController.text;
    String pass = _passwordController.text;

    if (user == 'admin' && pass == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    } else {
      setState(() {
        _error = 'Username atau password salah!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(_error, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}

// ---------------- MAIN MENU ----------------
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edvencer'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            MenuCard(
              title: 'To Do - List',
              subtitle: 'Menyimpan data ke database lokal',
              icon: Icons.storage,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MySQLiteExample()),
              ),
            ),
            const SizedBox(height: 16),
            MenuCard(
              title: 'Petualangan',
              subtitle: 'Alat untuk berpetualang',
              icon: Icons.home,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- MENU CARD ----------------
class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}