import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mad2_mtr/bomb.dart';
import 'package:mad2_mtr/main.dart';
import 'package:mad2_mtr/numberbox.dart';

class HomePage extends StatefulWidget {
  final String difficulty;
  final int level;
  const HomePage({super.key, required this.difficulty, required this.level});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numberOfLevels = 10;
  //grid variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  //[number of bombs around, revealed = true / false]
  var squareStatus = [];

  //bomb locations
  List<int> bombLocation = [];
  bool bombsRevealed = false;
  int elapsedTime = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Adjust number of levels based on difficulty
    if (widget.difficulty == 'Easy') {
      numberOfLevels = 5; // Easy
      numberOfSquares = 9 * 9; // Smaller grid for Easy difficulty
    } else if (widget.difficulty == 'Medium') {
      numberOfLevels = 10; // Medium
      numberOfSquares = 9 * 9; // Medium grid size
    } else if (widget.difficulty == 'Hard') {
      numberOfLevels = 15; // Hard
      numberOfSquares = 12 * 12; // Larger grid for Hard difficulty
    }

    //initially, each square has 0 bombs around, and is not revealed
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
    randomizeBombs();
    scanBombs();
    startTimer();
  }

  void randomizeBombs() {
    bombLocation.clear(); // Clear any previous bomb locations

    int numberOfBombs = 0;
    if (widget.difficulty == 'Easy') {
      numberOfBombs =
          widget.level; // For example, number of bombs equals the level
    } else if (widget.difficulty == 'Medium') {
      numberOfBombs = widget.level * 2; // More bombs for Medium
    } else if (widget.difficulty == 'Hard') {
      numberOfBombs = widget.level * 3; // Even more bombs for Hard
    }

    Random random = Random();

    // Use a Set to track bomb positions (faster for uniqueness)
    Set<int> bombSet = Set<int>();

    // Randomly select bomb positions
    while (bombSet.length < numberOfBombs) {
      int randomPosition = random.nextInt(numberOfSquares);
      bombSet.add(randomPosition); // Set ensures no duplicates
    }

    bombLocation = bombSet.toList(); // Convert Set to List for further use
    setState(() {}); // Trigger UI update
  }

  void startTimer() {
  // Start the timer to update elapsed time every second
  timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    if (mounted) {  // Check if the widget is still in the widget tree
      setState(() {
        elapsedTime++;  // Increment elapsed time
      });
    }
  });
}


  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void restartGame() {
    setState(() {
      bombsRevealed = false;
      elapsedTime = 0; // Reset the time when restarting
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }
    });

    randomizeBombs();
    scanBombs();
    startTimer(); // Restart the timer when the game restarts
  }

  String formatTime(int time) {
    int minutes = (time ~/ 60);
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void revealBoxNumbers(int index) {
    //reveal current box if it is a number: 1,2,3 etc
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
    }
    //if current box is 0
    else if (squareStatus[index][0] == 0) {
      //reveal current box and the 8 surrounding boxes, unless you're on a wall
      setState(() {
        //reveal current box
        squareStatus[index][1] = true;

        //reveal left box unless you are currently on the left wall
        if (index % numberInEachRow != 0) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }

          //reveal the left box
          squareStatus[index - 1][1] = true;
        }

        //reveal top left box unless you are currently on the top row or left wall
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }

          //reveal the top left box
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        //reveal top box unless you are on the top row
        if (index >= numberInEachRow) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }

          //reveal the top box
          squareStatus[index - numberInEachRow][1] = true;
        }

        //reveal top right box unless you are on the top row or the right wall
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 - numberInEachRow);
          }

          //reveal the top right box
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        //reveal right box unless you are on the right wall
        if (index % numberInEachRow != numberInEachRow - 1) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }

          //reveal the right box
          squareStatus[index + 1][1] = true;
        }

        //reveal bottom right box unless you are on the bottom row or the right wall
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }

          //reveal the bottom right box
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        //reveal bottom box unless you are on the bottom row
        if (index < numberOfSquares - numberInEachRow) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }

          //reveal the bottom box
          squareStatus[index + numberInEachRow][1] = true;
        }

        //reveal bottom left box unless you are on the bottom row or the left wall
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          //if next box isn't revealed yet and it is a 0, then recurse
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 + numberInEachRow);
          }

          //reveal the left box
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      //there are no bombs around initially
      int numberOfBombsAround = 0;

      /* 
        check each square to see if it has bombs surrounding it,
        there are 8 surrounding boxes to check
      */

      //check square to the left, unless it is in the first column
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      //check square to the top left, unless it is in the first column or first row
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      //check square to the top, unless it is in the first row or last column
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      //check square to the top right, unless it is in the first column or first row
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      //check square to the right, unless it is in the last column
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      //check square to the bottom right, unless it is in the last column or last row
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      //check square to the bottom, unless it is in the last row
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }

      //check square to the bottom left, unless it is in the last row or first column
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      //add total number of bombs around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text(
              'NATALO KA! HAHAHAHA',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            Center(
              child: MaterialButton(
                color: Colors.grey[100],
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: Icon(Icons.refresh),
              ),
            ),
          ],
        );
      },
    );
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text('NANALO KA!', style: TextStyle(color: Colors.white)),
          ),
          actions: [
            Center(
              child: MaterialButton(
                onPressed: () {
                  restartGame();
                  Navigator.pop(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: Colors.grey[300],
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.refresh, size: 30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void checkWinner() {
    //check how many boxes yet to reveal
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }

    //if this number is the same as the number of bombs, then you win
    if (unrevealedBoxes == bombLocation.length) {
      playerWon();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor;

    if (widget.difficulty == 'Easy') {
      appBarColor = Colors.blue;
    } else if (widget.difficulty == 'Medium') {
      appBarColor = const Color.fromARGB(255, 195, 181, 59);
    } else if (widget.difficulty == 'Hard') {
      appBarColor = Colors.red;
    } else {
      appBarColor = Colors.blue;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),

        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(color: appBarColor),
          ),
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'Pests Sweeper - ${widget.difficulty}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Level: ${widget.level}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 10,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Game stats and menu
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  // Display number of bombs
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bombLocation.length.toString(),
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      Text('B O M B', style: TextStyle(color: Colors.white)),
                    ],
                  ),

                  // Refresh game button
                  GestureDetector(
                    onTap: restartGame,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.refresh, color: appBarColor, size: 40),
                    ),
                  ),
                  // Display time consumed
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatTime(
                          elapsedTime,
                        ), // Format and display time as MM:SS
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      Text('T I M E', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            // Game grid
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInEachRow,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  if (bombLocation.contains(index)) {
                    return MyBomb(
                      revealed: bombsRevealed,
                      function: () {
                        setState(() {
                          bombsRevealed = true;
                        });
                        playerLost();
                      },
                    );
                  } else {
                    return MyNumberBox(
                      child: squareStatus[index][0],
                      revealed: squareStatus[index][1],
                      function: () {
                        revealBoxNumbers(index);
                        checkWinner();
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                'P E S T S W E E P E R',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: appBarColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
