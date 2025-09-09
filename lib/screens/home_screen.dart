// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

// Import your feature screens (will create these next)
import 'disease_diagnosis_screen.dart';
import 'crop_prices_screen.dart';
import 'scheme_details_screen.dart';
import 'rental_organizations_screen.dart';
import 'weather_details_screen.dart';
import 'chatbot_screen.dart'; // We'll create this

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plasonisis Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildFeatureCard(
              context,
              'Disease Diagnosis',
              Icons.healing,
              Colors.red.shade700,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiseaseDiagnosisScreen())),
            ),
            _buildFeatureCard(
              context,
              'Crop Prices',
              Icons.agriculture,
              Colors.orange.shade700,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CropPricesScreen())),
            ),
            _buildFeatureCard(
              context,
              'Scheme Details',
              Icons.description,
              Colors.blue.shade700,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemeDetailsScreen())),
            ),
            _buildFeatureCard(
              context,
              'Rental Organizations',
              Icons.handshake,
              Colors.purple.shade700,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalOrganizationsScreen())),
            ),
            _buildFeatureCard(
              context,
              'Weather Details',
              Icons.cloud,
              Colors.teal.shade700,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherDetailsScreen())),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
        },
        backgroundColor: Colors.green.shade800,
        child: const Icon(Icons.chat, color: Colors.white),
        tooltip: 'AI Chatbot',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}