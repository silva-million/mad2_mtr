import 'package:flutter/material.dart';
import 'package:mad2_mtr/homepage.dart';

class DifficultyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Choose Difficulty', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DifficultyButton(level: 'Easy', onTap: () { _startGame(context, 'Easy'); }),
          SizedBox(height: 10),
          DifficultyButton(level: 'Medium', onTap: () { _startGame(context, 'Medium'); }),
          SizedBox(height: 10),
          DifficultyButton(level: 'Hard', onTap: () { _startGame(context, 'Hard'); }),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  void _startGame(BuildContext context, String difficulty) {
    Navigator.pop(context);
    _showLevelDialog(context, difficulty);
  }

  void _showLevelDialog(BuildContext context, String difficulty) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); 
                },
              ),
              Text('Select Level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Container(
            width: 300, 
            height: 400, 
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10, 
                childAspectRatio: 2.0,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          difficulty: difficulty,
                          level: index + 1, 
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.blueAccent,
                    child: Center(
                      child: Text(
                        'Level ${index + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String level;
  final VoidCallback onTap;

  DifficultyButton({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(level, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        fixedSize: Size(200, 60),
      ),
    );
  }
}
