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
  final List<Map<String, String>> mots = [
    {"mot": "BONJOU", "endis": "Se yon mo ki itilize pou salye moun"},
    {"mot": "LEKOL", "endis": "Se kote yo bay edikasyon"},
    {"mot": "LAPLI", "endis": "Li tonbe nan syèl lè tan an pa bon"},
    {"mot": "AYITI", "endis": "Se yon peyi nan Karayib la"},
  ];

  late String motCache;
  late String endis;
  int chances = 5;

  List<String> lettresTrouvees = [];
  List<String> lettresUtilisees = [];

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
    final selected = mots[random.nextInt(mots.length)];
    motCache = selected["mot"]!;
    endis = selected["endis"]!;
    chances = 5;
    lettresTrouvees.clear();
    lettresUtilisees.clear();
  }

  String afficherMot() {
    return motCache.split('').map((lettre) {
      return lettresTrouvees.contains(lettre) ? lettre : '*';
    }).join(' ');
  }

  void onLettreCliquee(String lettre) {
    if (lettresUtilisees.contains(lettre)) return;

    setState(() {
      lettresUtilisees.add(lettre);

      if (motCache.contains(lettre)) {
        lettresTrouvees.add(lettre);
        _controller.forward(from: 0);
      } else {
        chances--;
      }

      if (!afficherMot().contains('*')) {
        allerResultat(true);
      } else if (chances == 0) {
        allerResultat(false);
      }
    });
  }

  void allerResultat(bool gagne) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          gagne: gagne,
          motCache: motCache,
        ),
      ),
    );
  }

  Color couleurBouton(String lettre) {
    if (lettresTrouvees.contains(lettre)) return Colors.green;
    if (lettresUtilisees.contains(lettre)) return Colors.grey;
    return const Color.fromARGB(255, 7, 23, 241);
  }

  Widget _buildRow(List<String> lettres) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lettres.map((lettre) {
        final dejaUtilisee = lettresUtilisees.contains(lettre);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            width: 42,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: couleurBouton(lettre),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed:
                  dejaUtilisee ? null : () => onLettreCliquee(lettre),
              child: Text(
                lettre,
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
            child: Center(child: Text("Chans: $chances")),
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
                afficherMot(),
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
              endis,
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
  final bool gagne;
  final String motCache;

  const ResultScreen({
    super.key,
    required this.gagne,
    required this.motCache,
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
                gagne ? "🎉 Ou Genyen !" : "😢 Ou Pèdi !",
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (!gagne) ...[
                const SizedBox(height: 10),
                Text(
                  "Mo a te: $motCache",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.yellowAccent,
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