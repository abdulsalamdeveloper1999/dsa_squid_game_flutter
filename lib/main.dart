import 'package:flutter/material.dart';
import 'models/game_state.dart';
import 'services/audio_service.dart';
import 'widgets/lobby_screen.dart';
import 'widgets/game_screen.dart';
import 'problems/leetcode_problems.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show SystemNavigator;
import 'widgets/leave_screen.dart';
import 'utils/code_checker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DSAChallenge(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFFF0266), // Squid Game pink
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          color: Color(0xFF1A1A1A), // Dark gray for cards
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFFF0266),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF0266),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Color(0xFFFF0266),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DSAChallenge extends StatefulWidget {
  const DSAChallenge({super.key});

  @override
  _DSAChallengeState createState() => _DSAChallengeState();
}

class _DSAChallengeState extends State<DSAChallenge> {
  GameState gameState = GameState.lobby;
  final AudioService audioService = AudioService();
  bool isGreenLight = false;
  int timeRemaining = 300;
  String code = "// Write your solution here\n";
  bool isSoundEnabled = true;

  late Timer _timer;
  late Timer _lightTimer;

  final problem = LeetCodeProblems.containsDuplicate;

  // Add this near the other state variables at the top of the class
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: problem.startingCode);

    // Start lobby music immediately for non-web platforms
    if (!kIsWeb) {
      audioService.playLobbyMusic();
    } else {
      // For web, show dramatic start dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                '⚠️ WARNING ⚠️',
                style: TextStyle(
                  color: Color(0xFFFF0266),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You are about to enter the DSA Squid Game.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Once you start, there is no turning back until you win or get eliminated.',
                    style: TextStyle(
                      color: Color(0xFFFF0266),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Do you wish to continue?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        audioService.playLobbyMusic();
                      },
                      child: Text(
                        'ACCEPT',
                        style: TextStyle(
                          color: Color(0xFFFF0266),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeaveScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'LEAVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      });
    }
  }

  // Format time in MM:SS
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsFormatted = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secondsFormatted";
  }

  // Update returnToLobby method to restart lobby music
  void returnToLobby() {
    setState(() {
      gameState = GameState.lobby;
      timeRemaining = 300;
      code = "// Write your solution here\n";
      _codeController.text = problem.startingCode;
    });
    _timer.cancel();
    _lightTimer.cancel();
    audioService.gamePlayer.stop();
    audioService.playLobbyMusic();
  }

  // Add this method to check solution
  void checkSolution() {
    bool isCorrect = CodeChecker.checkPythonSolution(_codeController.text);

    if (isCorrect) {
      setState(() {
        gameState = GameState.won;
        _timer.cancel();
        _lightTimer.cancel();
      });
      audioService.gamePlayer.stop();
      _codeController.text = problem.startingCode;
    } else {
      // Play elimination sound for warning
      audioService.playGameSound('eliminated');

      // Show warning dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Color(0xFFFF0266),
                width: 2,
              ),
            ),
            title: Text(
              '⚠️ WARNING ⚠️',
              style: TextStyle(
                color: Color(0xFFFF0266),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Test Cases Failed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Your solution failed some test cases.\nBe careful! Next failure might be your last...',
                  style: TextStyle(
                    color: Color(0xFFFF0266),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'I Understand',
                    style: TextStyle(
                      color: Color(0xFFFF0266),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      setState(() {
        if (timeRemaining <= 60) {
          gameState = GameState.eliminated;
          _timer.cancel();
          _lightTimer.cancel();
        } else {
          timeRemaining -= 60;
        }
      });
    }
  }

  // Add this method to _DSAChallengeState
  void startGame() {
    audioService.stopLobbyMusic();
    showCountdownDialog();
  }

  // Add this method as well
  void showCountdownDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Color(0xFFFF0266),
              width: 2,
            ),
          ),
          title: Text(
            'Get Ready!',
            style: TextStyle(
              color: Color(0xFFFF0266),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Game starts in 5 seconds...',
              style: TextStyle(
                color: Color(0xFFFF0266),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pop();
      startGameSequence();
    });
  }

  void startGameSequence() async {
    setState(() {
      gameState = GameState.playing;
      timeRemaining = 300;
      code = "// Write your solution here\n";
      isGreenLight = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          gameState = GameState.eliminated;
          audioService.playGameSound('eliminated');
          _timer.cancel();
          _lightTimer.cancel();
        }
      });
    });

    audioService.playGameSound('green');
    await Future.delayed(Duration(seconds: 2));

    _lightTimer = Timer.periodic(Duration(seconds: 12), (timer) {
      setState(() {
        isGreenLight = !isGreenLight;
        if (isGreenLight) {
          audioService.playGameSound('green');
        } else {
          audioService.playGameSound('red');
        }
      });
    });
  }

  // Add this method to handle first interaction
  void handleSoundToggle() {
    setState(() {
      isSoundEnabled = !isSoundEnabled;
      if (isSoundEnabled && gameState == GameState.lobby) {
        audioService.playLobbyMusic();
      } else {
        audioService.stopLobbyMusic();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _timer.cancel();
    _lightTimer.cancel();
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("DSA Squid Game"),
        actions: [
          IconButton(
            icon: Icon(isSoundEnabled ? Icons.volume_up : Icons.volume_off),
            onPressed: handleSoundToggle,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              kIsWeb ? 'assets/web_bg.jpg' : 'assets/Background.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (gameState == GameState.lobby) ...[
                LobbyScreen(onStartGame: startGame),
              ],
              if (gameState == GameState.playing) ...[
                GameScreen(
                  timeRemaining: formatTime(timeRemaining),
                  isGreenLight: isGreenLight,
                  problem: problem,
                  codeController: _codeController,
                  onCodeChanged: (value) {
                    if (!isGreenLight && gameState == GameState.playing) {
                      setState(() {
                        gameState = GameState.eliminated;
                        audioService.playGameSound('eliminated');
                      });
                    }
                    setState(() {
                      code = value;
                    });
                  },
                  onSubmit: () {
                    checkSolution();
                  },
                ),
              ],
              if (gameState == GameState.eliminated) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "You have been eliminated!",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: returnToLobby,
                          child: Text("Return to Lobby"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (gameState == GameState.won) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 50,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Congratulations!",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "You've won ¥1,000,000,000!",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: returnToLobby,
                          child: Text("Play Again"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
