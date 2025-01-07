import 'package:flutter/material.dart';

class LobbyScreen extends StatelessWidget {
  final VoidCallback onStartGame;

  const LobbyScreen({super.key, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Welcome to DSA Squid Game!",
              style: TextStyle(
                color: Color(0xFFFF0266),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Rules:\n- Solve the coding problem\n- Type during Green Light\n- Stop typing during Red Light\n- Type during Red Light and you're out!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onStartGame,
              child: Text("Start Challenge"),
            ),
          ],
        ),
      ),
    );
  }
}
