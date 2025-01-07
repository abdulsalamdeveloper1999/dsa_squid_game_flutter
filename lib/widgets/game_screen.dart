import 'package:flutter/material.dart';
import '../problems/leetcode_problems.dart';

class GameScreen extends StatefulWidget {
  final String timeRemaining;
  final bool isGreenLight;
  final LeetCodeProblem problem;
  final TextEditingController codeController;
  final Function(String) onCodeChanged;
  final VoidCallback onSubmit;

  const GameScreen({
    super.key,
    required this.timeRemaining,
    required this.isGreenLight,
    required this.problem,
    required this.codeController,
    required this.onCodeChanged,
    required this.onSubmit,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Time Remaining: ${widget.timeRemaining}",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 16),
            Container(
              color: widget.isGreenLight ? Colors.green : Colors.red,
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.isGreenLight
                    ? "Green Light - Type!"
                    : "Red Light - Stop!",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.problem.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(widget.problem.description),
                  SizedBox(height: 8),
                  Text(
                    'Examples:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.problem.exampleInput),
                  Text(widget.problem.exampleOutput),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              focusNode: focusNode,
              controller: widget.codeController,
              onChanged: widget.onCodeChanged,
              maxLines: 10,
              style: TextStyle(
                color: Color(0xFFFF0266),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0266)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0266), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0266)),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.black.withOpacity(0.7),
                filled: true,
                hintText: 'Write your solution here...',
                hintStyle: TextStyle(color: Color(0xFFFF0266).withOpacity(0.5)),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF0266),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 8,
                shadowColor: Color(0xFFFF0266).withOpacity(0.5),
              ),
              child: Text(
                "Submit Solution",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
