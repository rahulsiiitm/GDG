// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';
import 'plantation_screen.dart';
import 'profile_page.dart';
import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService = WeatherService();
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  // Add a selected index variable
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      var data = await weatherService.fetchWeather();
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Navigation method
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlantationScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Ensures no white background
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),

            RefreshIndicator(
              onRefresh: () async {
                setState(() => isLoading = true);
                await weatherService.fetchWeather();
              },
              child: ListView(
                children: [
                  _buildHeader(), // Location & Profile Header
                  _buildWeatherCard(), // Weather Card
                  _buildTasksGrid(), // Agricultural Tasks
                  _buildFieldDetailsCard(), // Field Details
                ],
              ),
            ),
          ],
        ),
      ),

      // Enhanced Bottom Navigation Bar
      // Separated Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white),
              Text(
                weatherData?['name'] ?? 'Location loading...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/app_icon.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent() {
    final main = weatherData!['main'];
    final weather = weatherData!['weather'][0];
    final wind = weatherData!['wind'];

    // Get dynamic weather icon based on description
    final weatherIcon = _getWeatherIcon(weather['description']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(
              weatherIcon,
              size: 60, // Reduced from 80
              color: Colors.white.withOpacity(0.9),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${weatherData!['name']} Weather",
                    style: TextStyle(
                      fontSize: 18, // Reduced from 22
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${main['temp'].toStringAsFixed(1)}°C",
                    style: TextStyle(
                      fontSize: 30, // Reduced from 36
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "${weather['description']}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ), // Reduced from 18
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  size: 20,
                  color: Colors.white,
                ), // Reduced from 24
                SizedBox(width: 6),
                Text(
                  "${main['humidity']}% Humidity",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ), // Reduced from 16
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.air,
                  size: 20,
                  color: Colors.white,
                ), // Reduced from 24
                SizedBox(width: 6),
                Text(
                  "${wind['speed'].toStringAsFixed(1)} km/h Wind",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ), // Reduced from 16
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Also, update the _buildWeatherCard method to reduce height:
  Widget _buildWeatherCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        height: 220, // Reduced from 250
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Reduced from 24.0
          child:
              isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                  )
                  : errorMessage != null
                  ? Center(
                    child: Text(
                      'Error: $errorMessage',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                  : weatherData != null
                  ? _buildWeatherContent()
                  : Center(
                    child: Text(
                      'No weather data available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
        ),
      ),
    );
  }

  // Reuse the previous _getWeatherIcon method from the last implementation
  IconData _getWeatherIcon(String weatherDescription) {
    weatherDescription = weatherDescription.toLowerCase();

    if (weatherDescription.contains('clear')) {
      return Icons.wb_sunny_outlined;
    } else if (weatherDescription.contains('cloud')) {
      return Icons.cloud_outlined;
    } else if (weatherDescription.contains('rain')) {
      return Icons.water_drop_outlined;
    } else if (weatherDescription.contains('storm')) {
      return Icons.thunderstorm_outlined;
    } else if (weatherDescription.contains('snow')) {
      return Icons.ac_unit_outlined;
    } else if (weatherDescription.contains('mist') ||
        weatherDescription.contains('fog')) {
      return Icons.foggy;
    } else {
      return Icons.wb_cloudy_outlined;
    }
  }

  Widget _buildTasksGrid() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            _buildTaskCard(
              time: '7:30 AM',
              title: 'Watering of fields CD5',
              status: 'On-Progress',
              color: Colors.green.shade200.withOpacity(0.7),
            ),
            _buildTaskCard(
              time: '8:00 AM',
              title: 'Planting of fields CD5',
              status: 'Not-Started',
              color: Colors.white.withOpacity(0.6),
            ),
            _buildTaskCard(
              time: '8:30 AM',
              title: 'Watering of fields R8',
              status: 'Not-Started',
              color: Colors.white.withOpacity(0.6),
            ),
            _buildTaskCard(
              time: '6:30 AM',
              title: 'Watering of fields R10',
              status: 'Not-Started',
              color: Colors.white.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String time,
    required String title,
    required String status,
    Color? color,
  }) {
    return Card(
      color: color ?? Colors.white.withOpacity(0.6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Text(
              status,
              style: GoogleFonts.poppins(
                color:
                    status == 'On-Progress'
                        ? Colors
                            .green
                            .shade700 // Darker, more visible green
                        : Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w500, // Slightly bolder
                fontSize: 12, // Slightly smaller to fit better
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update the _buildFieldDetailsCard method
  Widget _buildFieldDetailsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.white.withOpacity(0.6),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Circular image with slight border
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/rice.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rice Field Premium Plot R8',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '7°44\'4.1"S, 110°22\'10.2"E',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Towards Harvest',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.green.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
