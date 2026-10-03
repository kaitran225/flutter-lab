import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lab10_1_mock_login.dart';
import 'lab10_2_real_api_login.dart';
import 'lab10_3_auto_login_logout.dart';
import 'lab10_4_firebase_google_sign_in.dart';
import 'lab10_5_notification.dart';
import 'lab10_full.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization skipped: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRM Lab 10',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      home: const LabMenu(),
    );
  }
}

class LabMenu extends StatelessWidget {
  const LabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(title: const Text('PRM Lab 10 Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(context, 'Lab 10.1: Mock Login', const MockLoginApp(), Icons.lock_outline),
          _item(context, 'Lab 10.2: Real API Login', const RealApiLoginApp(), Icons.cloud_outlined),
          _item(context, 'Lab 10.3: Auto Login & Logout', const AutoLoginApp(), Icons.timer_outlined),
          _item(context, 'Lab 10.4: Firebase Google Sign-In', const FirebaseGoogleSignInApp(), Icons.g_mobiledata),
          _item(context, 'Lab 10.5: Local Notifications', const NotificationApp(), Icons.notifications_outlined),
          const Divider(height: 32),
          _item(context, 'LAB 10 FULL: INTEGRATED APP', const Lab10FullApp(), Icons.apps, bold: true),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, Widget app, IconData icon, {bool bold = false}) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.surfaceContainerHighest,
          foregroundColor: cs.onSurface,
          child: Icon(icon, size: 22),
        ),
        title: Text(title, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
        trailing: Icon(Icons.chevron_right, color: cs.outline),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => app)),
      ),
    );
  }
}
