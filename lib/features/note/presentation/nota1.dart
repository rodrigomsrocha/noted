import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NotaHabito extends StatefulWidget {
  const NotaHabito({super.key});

  @override
  State<NotaHabito> createState() => _NotaHabitoState();
}

class _NotaHabitoState extends State<NotaHabito> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void tocarAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sticky_note_2,
                        color: Color.fromARGB(255, 161, 64, 251)),
                    SizedBox(width: 8),
                    Text(
                      "Noted!",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Guia Básico para Criar um Hábito Saudável 💪🍏",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit,
                          color: Color.fromARGB(255, 136, 64, 251)),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Defina um Objetivo Claro 🎯",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Ter um motivo forte para criar um hábito aumenta as chances de sucesso. Pergunte-se: Por que quero adotar esse hábito? Seja melhorar a alimentação, praticar exercícios regularmente ou dormir melhor, um objetivo claro mantém a motivação alta.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/nota_imagem.jpg',
                    fit: BoxFit.contain,
                    height: 500,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Associe a um Hábito Existente 🌊",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "• Quer beber mais água? Tome um copo toda vez que escovar os dentes.",
                          style: TextStyle(color: Colors.white70)),
                      Text("• Quer meditar? Faça isso logo após acordar.",
                          style: TextStyle(color: Colors.white70)),
                      Text(
                          "• Quer fazer exercícios? Tente encaixá-los antes do banho da noite.",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Comece Pequeno 📉",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.purpleAccent,
                          size: 32,
                        ),
                        onPressed: tocarAudio,
                      ),
                      Expanded(
                        child: Slider(
                          value: 0.3,
                          onChanged: (value) {},
                          activeColor: const Color.fromARGB(255, 89, 5, 199),
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const Text(
                        "02:31",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
