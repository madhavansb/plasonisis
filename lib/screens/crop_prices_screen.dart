import 'package:flutter/material.dart';

class CropPricesScreen extends StatelessWidget {
  const CropPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Current Prices'),
      ),
      body: const Center(
        child: Text('Content for Crop Current Prices will go here.'),
      ),
    );
  }
}