// ignore_for_file: avoid_print, use_super_parameters

// import 'package:AgriHive/home_screen.dart';
import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/services.dart';
import 'language_selection_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();
  await _initializeHive();
  await _initializeGemini();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();
    await Hive.openBox('chatbox');
    print("Hive initialized successfully");
  } catch (e) {
    print("Error initializing Hive: $e");
  }
}

Future<void> _initializeGemini() async {
  String apiKey = await _loadApiKey();
  if (apiKey.isNotEmpty) {
    try {
      Gemini.init(apiKey: apiKey);
      print(
        "Gemini initialized with API key: ${apiKey.substring(0, 3)}...${apiKey.substring(apiKey.length - 3)}",
      );
    } catch (e) {
      print("Error initializing Gemini: $e");
    }
  } else {
    print("ERROR: Gemini API key is missing or invalid!");
  }
}

Future<String> _loadApiKey() async {
  try {
    await dotenv.load(fileName: "assets/.env");
    String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      print(
        "No API key found in .env file, attempting to read from assets directly",
      );
      final String envFile = await rootBundle.loadString('assets/.env');
      for (var line in envFile.split('\n')) {
        if (line.startsWith('GEMINI_API_KEY=')) {
          return line.substring('GEMINI_API_KEY='.length).trim();
        }
      }
    }
    return apiKey;
  } catch (e) {
    print("Error loading API key: $e");
    return '';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriHive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: HomeScreen(),
      routes: {
        '/login': (context) => const LanguageSelectionScreen(),
        '/home':
            (context) => HomeScreen(), // Ensure HomeScreen is registered
        '/register':
            (context) => Scaffold(
              appBar: AppBar(title: const Text('Register')),
              body: const Center(child: Text('Register Screen Placeholder')),
            ),
      },
    );
  }
}
