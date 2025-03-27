// // ignore_for_file: avoid_print, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'chat_screen.dart';
// import 'plantation_screen.dart';
// import 'weather_service.dart';
// import 'profile_page.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final WeatherService weatherService = WeatherService();
//   Map<String, dynamic>? weatherData;
//   bool isLoading = true;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//   }

//   void fetchWeather() async {
//     try {
//       var data = await weatherService.fetchWeather();
//       setState(() {
//         weatherData = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error fetching weather: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   void _onItemTapped(int index) {
//     if (index == _selectedIndex) return;

//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navigate based on selected index
//     switch (index) {
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ChatScreen()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => PlantationScreen()),
//         );
//         break;
//       case 3:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => UserProfilePage()),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green[700],
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.green[700]!, Colors.green[100]!],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Weather Card
//               Card(
//                 elevation: 6,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.wb_sunny, size: 50, color: Colors.amber),
//                       const SizedBox(width: 16),
//                       // Inside the weather card
//                       isLoading
//                           ? const CircularProgressIndicator()
//                           : weatherData != null && weatherData!['main'] != null
//                           ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Weather in ${weatherData!['name'] ?? 'Unknown'}",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 "${weatherData!['main']?['temp']?.toString() ?? 'N/A'}°C, "
//                                 "${weatherData!['weather']?[0]?['description'] ?? 'No data'}",
//                                 style: const TextStyle(fontSize: 22),
//                               ),
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.water_drop,
//                                     size: 16,
//                                     color: Colors.blue,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "${weatherData!['main']?['humidity']?.toString() ?? 'N/A'}% Humidity",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Icon(
//                                     Icons.air,
//                                     size: 16,
//                                     color: Colors.blueGrey,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "${weatherData!['wind']?['speed']?.toString() ?? 'N/A'} km/h Wind",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                           : const Text("Failed to load weather"),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Daily Summary Card
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Today's Garden Status",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildStatusItem(
//                             Icons.opacity,
//                             "Water",
//                             "Good",
//                             Colors.blue,
//                           ),
//                           _buildStatusItem(
//                             Icons.wb_sunny,
//                             "Sun",
//                             "Optimal",
//                             Colors.orange,
//                           ),
//                           _buildStatusItem(
//                             Icons.thermostat,
//                             "Soil",
//                             "Needs Check",
//                             Colors.red,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Recent Activity
//               Expanded(
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Recent Activity",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         Expanded(
//                           child: ListView(
//                             children: [
//                               _buildActivityItem(
//                                 "Watered tomato plants",
//                                 "2 hours ago",
//                                 Icons.water,
//                               ),
//                               _buildActivityItem(
//                                 "Added fertilizer to roses",
//                                 "Yesterday",
//                                 Icons.grass,
//                               ),
//                               _buildActivityItem(
//                                 "Planted new herbs",
//                                 "2 days ago",
//                                 Icons.eco,
//                               ),
//                               _buildActivityItem(
//                                 "Pruned apple tree",
//                                 "1 week ago",
//                                 Icons.cut,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add quick action
//         },
//         backgroundColor: Colors.green[700],
//         child: Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Plantation'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: 'Statistics',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green[700],
//         unselectedItemColor: Colors.grey[600],
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         elevation: 8,
//       ),
//     );
//   }

//   Widget _buildStatusItem(
//     IconData icon,
//     String label,
//     String status,
//     Color color,
//   ) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 28),
//         SizedBox(height: 8),
//         Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(status, style: TextStyle(color: color)),
//       ],
//     );
//   }

//   Widget _buildActivityItem(String title, String time, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.green[100],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: Colors.green[700], size: 24),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(
//                   time,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
