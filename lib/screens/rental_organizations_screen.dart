import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RentalOrganizationsScreen extends StatelessWidget {
  const RentalOrganizationsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Organizations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRentalOrgCard(
              context,
              'Farm Equipment Rentals Inc.',
              'Providing a wide range of farm machinery for rent.',
              'https://www.example.com/farm-rentals',
            ),
            _buildRentalOrgCard(
              context,
              'AgriTools & Machines',
              'Your partner for modern agricultural tools and equipment.',
              'https://www.example.com/agritools',
            ),
            // Add more organizations here
          ],
        ),
      ),
    );
  }

  Widget _buildRentalOrgCard(BuildContext context, String name, String description, String url) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton.icon(
                onPressed: () => _launchUrl(url),
                icon: const Icon(Icons.link),
                label: const Text('Visit Website'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  side: BorderSide(color: Colors.green.shade700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}