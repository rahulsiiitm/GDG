// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Profile Management
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User profile not found');
      }

      return {
        'name': userDoc['name'] ?? 'N/A',
        'email': currentUser.email ?? 'N/A',
        'location': userDoc['location'] ?? 'N/A',
        'plantations': userDoc['plantations'] ?? 0,
        'totalArea': userDoc['totalArea'] ?? 0,
        'healthyPlants': userDoc['healthyPlants'] ?? 0,
        'membership': userDoc['membership'] ?? 'Basic',
        'joinDate': (userDoc['joinDate'] as Timestamp?)?.toDate().toString() ?? 'N/A'
      };
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // Update User Profile
  Future<void> updateUserProfile({
    String? name,
    String? location,
  }) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      Map<String, dynamic> updateData = {};
      
      if (name != null) updateData['name'] = name;
      if (location != null) updateData['location'] = location;

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(updateData);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Fetch Recent Plant Scans
  Future<List<Map<String, dynamic>>> fetchRecentPlantScans() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      QuerySnapshot scanSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('plantScans')
          .orderBy('date', descending: true)
          .limit(3)
          .get();

      return scanSnapshot.docs.map((doc) => {
        'plantType': doc['plantType'] ?? 'Unknown',
        'status': doc['status'] ?? 'No Status',
        'date': (doc['date'] as Timestamp).toDate().toString()
      }).toList();
    } catch (e) {
      print('Error fetching plant scans: $e');
      return [];
    }
  }

  // Fetch Plantation Overview
  Future<Map<String, dynamic>> fetchPlantationOverview() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      DocumentSnapshot overviewDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('analytics')
          .doc('plantation_overview')
          .get();

      if (!overviewDoc.exists) {
        return {
          'climateData': 'Not Available',
          'irrigation': 'Not Configured',
          'soilHealth': 'Unknown'
        };
      }

      return {
        'climateData': overviewDoc['climateData'] ?? 'Monitored',
        'irrigation': overviewDoc['irrigation'] ?? 'Automated',
        'soilHealth': overviewDoc['soilHealth'] ?? 'Good'
      };
    } catch (e) {
      print('Error fetching plantation overview: $e');
      return {
        'climateData': 'Not Available',
        'irrigation': 'Not Configured',
        'soilHealth': 'Unknown'
      };
    }
  }
}