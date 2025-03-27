// ignore_for_file: use_super_parameters, library_private_types_in_public_api, prefer_final_fields, deprecated_member_use

import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the login screen

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  bool _isDarkMode = false;

  void _selectLanguage(String language) {
    if (language == 'English') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hindi language support coming soon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/Background2.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(_isDarkMode ? 0.6 : 0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                _buildAppName(),
                _buildLanguageSelectionText(),
                _buildLanguageButtons(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/path1.png',
      width: 100,
      height: 100,
      color: Colors.white,
    );
  }

  Widget _buildAppName() {
    return const Text(
      'AgriHive',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLanguageSelectionText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        'Select your Language',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildLanguageButtons() {
    return Column(
      children: [
        _buildLanguageButton('English'),
        const SizedBox(height: 15),
        _buildLanguageButton('हिन्दी', isHindi: true),
      ],
    );
  }

  Widget _buildLanguageButton(String text, {bool isHindi = false}) {
    return ElevatedButton(
      onPressed: () => _selectLanguage(isHindi ? 'Hindi' : 'English'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.3),
        foregroundColor: Colors.white, // Set button text to white
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white, // Ensure text remains white
        ),
      ),
    );
  }
}
