import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Title
              const Text(
                'Race Tracking App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Race tracking buttons
              _buildNavigationButton(
                  context, 'Track Running', Icons.directions_run, '/running'),
              const SizedBox(height: 16),
              _buildNavigationButton(
                  context, 'Track Swimming', Icons.pool, '/swimming'),
              const SizedBox(height: 16),
              _buildNavigationButton(
                  context, 'Track Cycling', Icons.directions_bike, '/cycling'),
              const SizedBox(height: 32),

              // Results button
              _buildNavigationButton(
                  context, 'View Results', Icons.emoji_events, '/result',
                  isPrimary: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String title, IconData icon, String route,
      {bool isPrimary = false}) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue : Colors.grey[200],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
