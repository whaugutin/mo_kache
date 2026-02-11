import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mo Kache',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

// ===================== Game Main Screen =====================
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> words = [
  {"mot": "MANMAN", "endis": "Se fanm ki bay lavi"},
  {"mot": "PAPA", "endis": "Se gason ki gen pitit"},
  {"mot": "DLO", "endis": "Nou bwè li pou viv"},
  {"mot": "PYE", "endis": "Li ede nou mache"},
  {"mot": "MEN", "endis": "Nou itilize li pou kenbe bagay"},
  {"mot": "LALIN", "endis": "Li klere lannwit"},
  {"mot": "ZANMI", "endis": "Se moun ou renmen anpil"},
  {"mot": "KAY", "endis": "Se kote ou rete"},
  {"mot": "MACHE", "endis": "Se kote yo vann pwodwi"},
  {"mot": "LEGIM", "endis": "Manje ki soti nan tè"},
  {"mot": "DIRI", "endis": "Manje prensipal anpil Ayisyen"},
  {"mot": "LIV", "endis": "Ou li li pou aprann"},
  {"mot": "LEKOL", "endis": "Se kote yo bay edikasyon"},
  {"mot": "AYITI", "endis": "Se yon peyi nan Karayib la"},
  {"mot": "KREYOL", "endis": "Lang nou pale an Ayiti"},
  {"mot": "LAKAY", "endis": "Yon lòt fason pou di kay"},
  {"mot": "CHEN", "endis": "Bèt ki konn veye kay"},
  {"mot": "CHAT", "endis": "Bèt ki renmen chase sourit"},
  {"mot": "PWASON", "endis": "Li viv nan dlo"},
  {"mot": "MONT", "endis": "Li montre lè"},
  {"mot": "RAD", "endis": "Ou mete li sou kò ou"},
  {"mot": "LARI", "endis": "Machin pase ladan li"},
  {"mot": "PON", "endis": "Li ede travèse dlo"},
  {"mot": "MIZIK", "endis": "Ou tande li pou pran plezi"},
  {"mot": "DANSE", "endis": "Ou fè li sou mizik"},
  {"mot": "SANTE", "endis": "Lè ou pa malad"},
  {"mot": "LOPITAL", "endis": "Yo mennen moun malad la"},
  {"mot": "MEDSEN", "endis": "Li trete moun malad"},
  {"mot": "JADEN", "endis": "Kote yo plante flè ak legim"},
  {"mot": "MANGO", "endis": "Fwi dous anpil nan sezon cho"},
  {"mot": "BANNANN", "endis": "Fwi jòn ki long"},
];


  late String hiddenWord;
  late String index;
  int tries = 5;

  List<String> foundLetters = [];
  List<String> usedLetters = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initialiserJeu();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  void _initialiserJeu() {
    final random = Random();
    final selected = words[random.nextInt(words.length)];
    hiddenWord = selected["mot"]!;
    index = selected["endis"]!;
    tries = 5;
    foundLetters.clear();
    usedLetters.clear();
  }

  String displayWord() {
    return hiddenWord.split('').map((letter) {
      return foundLetters.contains(letter) ? letter : '*';
    }).join(' ');
  }

  void onClickKeyboard(String letter) {
    if (usedLetters.contains(letter)) return;

    setState(() {
      usedLetters.add(letter);

      if (hiddenWord.contains(letter)) {
        foundLetters.add(letter);
        _controller.forward(from: 0);
      } else {
        tries--;
      }

      if (!displayWord().contains('*')) {
        goToResult(true);
      } else if (tries == 0) {
        goToResult(false);
      }
    });
  }

  void goToResult(bool win) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          win: win,
          hiddenWord: hiddenWord,
        ),
      ),
    );
  }

  Color couleurBouton(String letter) {
    if (foundLetters.contains(letter)) return Colors.green;
    if (usedLetters.contains(letter)) return Colors.grey;
    return const Color.fromARGB(255, 7, 23, 241);
  }

  Widget _buildRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        final dejaUtilisee = usedLetters.contains(letter);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            width: 42,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: couleurBouton(letter),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
                  dejaUtilisee ? null : () => onClickKeyboard(letter),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mo Kache"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: Text("Chans: $tries")),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30), // word lower
            ScaleTransition(
              scale: _animation,
              child: Text(
                displayWord(),
                style: const TextStyle(
                  fontSize: 36,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              index,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(), // push keyboard down

            Column(
              children: [
                _buildRow(['Q','W','E','R','T','Y','U','I','O','P']),
                const SizedBox(height: 8),
                _buildRow(['A','S','D','F','G','H','J','K','L']),
                const SizedBox(height: 8),
                _buildRow(['Z','X','C','V','B','N','M']),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ===================== Result Screen =====================
class ResultScreen extends StatelessWidget {
  final bool win;
  final String hiddenWord;

  const ResultScreen({
    super.key,
    required this.win,
    required this.hiddenWord,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 7, 23, 241),
              Color.fromARGB(255, 27, 32, 102),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                win ? "Weeeeee ! Ou Genyen !" : "Wouch ! Ou Pèdi !",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!win) ...[
                const SizedBox(height: 10),
                Text(
                  "Mo a te: $hiddenWord",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text("Rejwe"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GameScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text("Kite"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}