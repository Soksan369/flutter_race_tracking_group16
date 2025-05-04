// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.9; // shrink on tap
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // bounce back
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🚀 Let’s go!')),
    );

    // TODO: Add your start logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/TriTrack.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  // Glowing circle + button
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow ring
                      Container(
                        width: 260, // larger than button
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.6),
                              blurRadius: 60,
                              spreadRadius: 30,
                            ),
                          ],
                        ),
                      ),

                      // Main Start button
                      GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        child: AnimatedScale(
                          scale: _scale,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              width: 220,
                              height: 220,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor: Colors.white24,
                                onTap: () {
                                  // Optional: additional tap handler
                                },
                                child: const Center(
                                  child: Text(
                                    'START',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 24),
                  // _buildNavigationButton(context, 'Track Running', Icons.directions_run, '/running'),
                  // const SizedBox(height: 16),
                  // _buildNavigationButton(context, 'Track Swimming', Icons.pool, '/swimming'),
                  // const SizedBox(height: 16),
                  // _buildNavigationButton(context, 'Track Cycling', Icons.directions_bike, '/cycling'),
                  // const SizedBox(height: 32),
                  // _buildNavigationButton(context, 'View Results', Icons.emoji_events, '/result', isPrimary: true),
                  const SizedBox(height: 78),
                  _buildNavigationButton(context, 'Add Participant', Icons.people, '/add_participant'),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    IconData icon,
    String route, {
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route),
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue : Colors.grey[200]?.withOpacity(0.8),
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
