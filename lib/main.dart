import 'package:chats/firebase_options.dart';
import 'package:chats/services/auth/auth_gate.dart';
import 'package:chats/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
            secondary: Colors.blue[200],
            tertiary: Colors.grey[200],
          ),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w200,
          ))),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
