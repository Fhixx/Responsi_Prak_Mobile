import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../data/services/session_service.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '-';

  // kesan & pesan kamu selama praktikum.
  static const String _email =
      'someone@gmail.com';
  static const String _jmlhgame =
      'ytta';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final name = await SessionService.getUsername();
    if (!mounted) return;
    setState(() => _username = name);
  }

  Future<void> _logout() async {
    await SessionService.clearSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF3A3A3C),
                child: Icon(Icons.person, size: 40, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Text(
                _username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Email: $_email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 4),
              const Text(
                'Game dimiliki: $_jmlhgame',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
