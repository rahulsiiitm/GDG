// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'navbar_widget.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'plantation_screen.dart';
import 'home_screen.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int _selectedIndex = 3; // Set to Statistics/Profile index
  bool _isEditing = false;

  // Initialize with default empty controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;

  // Hardcoded user details for an Indian farmer
  Map<String, dynamic> userDetails = {
    'name': 'Rajesh Kumar',
    'email': 'rajesh.kumar@farmmail.com',
    'location': 'Imphal, Manipur',
    'plantations': 5,
    'totalArea': 12.5, // hectares
    'healthyPlants': 450,
    'membership': 'Premium Farmer',
    'joinDate': 'March 15, 2022',
  };

  // Hardcoded recent plant scans
  List<Map<String, dynamic>> recentScans = [
    {
      'plantType': 'Grape Vine',
      'status': 'Healthy Growth',
      'date': '2024-03-20',
    },
    {
      'plantType': 'Onion Crop',
      'status': 'Mild Fungal Infection',
      'date': '2024-03-15',
    },
    {
      'plantType': 'Pomegranate Tree',
      'status': 'Healthy',
      'date': '2024-03-10',
    },
  ];

  // Hardcoded plantation overview
  Map<String, dynamic> plantationOverview = {
    'climateData': '24°C | 65% Humidity',
    'irrigation': 'Drip Irrigation Active',
    'soilHealth': 'pH 6.5 | Nutrient Rich',
  };

  // Menu options
  final List<Map<String, dynamic>> menuOptions = [
    {'icon': Icons.analytics, 'label': 'Analytics'},
    {'icon': Icons.camera_alt, 'label': 'Plant Scans'},
    {'icon': Icons.file_copy, 'label': 'Reports'},
    {'icon': Icons.chat_bubble, 'label': 'Consultation'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user details
    _nameController = TextEditingController(text: userDetails['name']);
    _emailController = TextEditingController(text: userDetails['email']);
    _locationController = TextEditingController(text: userDetails['location']);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (_isEditing) {
      // Save changes
      setState(() {
        userDetails['name'] = _nameController.text;
        userDetails['location'] = _locationController.text;
        _isEditing = false;
      });
    } else {
      // Enter edit mode
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlantationScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.green[600],
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Icon
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green[400],
                    child: Icon(Icons.eco, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 16),
                  // User Details
                  Expanded(
                    child:
                        _isEditing
                            ? _buildEditableProfileDetails()
                            : _buildProfileDetails(),
                  ),
                  // Edit/Save Button
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.save : Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: _toggleEditMode,
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Row(
                children: [
                  // Side Menu
                  Container(
                    width: 80,
                    color: Colors.green[100],
                    child: ListView.builder(
                      itemCount: menuOptions.length,
                      itemBuilder: (context, index) {
                        return IconButton(
                          icon: Icon(
                            menuOptions[index]['icon'] as IconData,
                            color:
                                _selectedIndex == index
                                    ? Colors.green[800]
                                    : Colors.green[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  // Content Area
                  Expanded(child: _buildContentArea()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userDetails['name'] ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white70, size: 16),
            Text(
              userDetails['location'] ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        Text(
          userDetails['email'] ?? '',
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildEditableProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
          ),
        ),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white70, size: 16),
            Expanded(
              child: TextField(
                controller: _locationController,
                style: const TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white54),
          decoration: InputDecoration(
            hintText: 'Enter email',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentArea() {
    switch (_selectedIndex) {
      case 0: // Analytics
        return _buildOverviewContent();
      case 1: // Plant Scans
        return _buildScansContent();
      case 4: // Disease Lab
        return _buildDiseaseLab();
      default:
        return Center(
          child: Text(
            'Coming Soon!',
            style: TextStyle(color: Colors.green[800], fontSize: 18),
          ),
        );
    }
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Plantation Stats Grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  icon: Icons.thermostat,
                  label: 'Climate Data',
                  value: plantationOverview['climateData'],
                ),
                _buildStatCard(
                  icon: Icons.water_drop,
                  label: 'Irrigation',
                  value: plantationOverview['irrigation'],
                ),
                _buildStatCard(
                  icon: Icons.air,
                  label: 'Soil Health',
                  value: plantationOverview['soilHealth'],
                ),
              ],
            ),

            // Membership Details
            const SizedBox(height: 16),
            Card(
              color: Colors.green[100],
              child: ListTile(
                title: Text(
                  'Membership Tier: ${userDetails['membership']}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Member Since: ${userDetails['joinDate']}',
                  style: TextStyle(color: Colors.green[600]),
                ),
                trailing: Icon(Icons.star, color: Colors.yellow[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      color: Colors.green[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green[600], size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.green[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildScansContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: recentScans.length,
      itemBuilder: (context, index) {
        final scan = recentScans[index];
        return Card(
          child: ListTile(
            title: Text(scan['plantType'] ?? ''),
            subtitle: Text(
              scan['status'] ?? '',
              style: TextStyle(
                color:
                    (scan['status'] as String).contains('Healthy')
                        ? Colors.green
                        : Colors.yellow[700],
              ),
            ),
            trailing: Text(scan['date'] ?? ''),
          ),
        );
      },
    );
  }

  Widget _buildDiseaseLab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science, size: 100, color: Colors.green[600]),
          const SizedBox(height: 16),
          Text(
            'Disease Laboratory',
            style: TextStyle(
              color: Colors.green[800],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Advanced plant disease detection',
            style: TextStyle(color: Colors.green[600]),
          ),
        ],
      ),
    );
  }
}
