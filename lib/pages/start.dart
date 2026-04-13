import 'package:flutter/material.dart';
import 'package:tetris/pages/game/game.dart';
import 'package:tetris/services/scores_service.dart';
import 'package:tetris/widgets/double_back_exit.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int level = 1;
  final Map<String, Duration> levelTimer = const {
    'Level-1': Duration(milliseconds: 750),
    'Level-2': Duration(milliseconds: 500),
    'Level-3': Duration(milliseconds: 250),
  };

  // High scores
  Map<dynamic, dynamic> _highScores = {};

  @override
  void initState() {
    super.initState();

    // Fetch function
    void fetchHighScores() async {
      final fetchedHighScores = await ScoresService().getAll();
      setState(() {
        _highScores = fetchedHighScores;
      });
    }

    fetchHighScores();
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        body: Center(
          child: Column(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'TETRIS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  IconButton(
                    onPressed: () {
                      if (level > 1) {
                        setState(() {
                          level--;
                        });
                      }
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('Level-$level'),
                  IconButton(
                    onPressed: () {
                      if (level < 3) {
                        setState(() {
                          level++;
                        });
                      }
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Game(
                        timer: levelTimer['Level-$level']!.inMilliseconds,
                        level: 'Level-$level',
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: Text('Play'),
              ),
              if (_highScores['Level-$level'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text("High Score: ${_highScores['Level-$level']}"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
