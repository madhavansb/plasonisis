import 'package:flutter/material.dart';

class DiseaseDiagnosisScreen extends StatelessWidget {
  const DiseaseDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Diagnosis'),
      ),
      body: const Center(
        child: Text('Content for Disease Diagnosis will go here.'),
      ),
    );
  }
}