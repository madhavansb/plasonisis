import 'package:flutter/material.dart';

class SchemeDetailsScreen extends StatelessWidget {
  const SchemeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Details'),
      ),
      body: const Center(
        child: Text('Content for Scheme Details will go here.'),
      ),
    );
  }
}