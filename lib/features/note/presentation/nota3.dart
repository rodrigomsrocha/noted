import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NotaMeditacao extends StatefulWidget {
  const NotaMeditacao({super.key});

  @override
  State<NotaMeditacao> createState() => _NotaMeditacaoState();
}

class _NotaMeditacaoState extends State<NotaMeditacao> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void tocarAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'));
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.self_improvement, color: Colors.tealAccent),
                    SizedBox(width: 8),
                    Text(
                      "Mindfulness",
                      style: TextStyle(
                        color: Colors.tealAccent,
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
                        "Dicas de Mindfulness 🧘‍♂️✨",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.tealAccent),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Respiração Consciente 🌬️",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Reserve alguns minutos por dia para focar apenas na sua respiração. Inspire profundamente e expire lentamente, sentindo cada movimento do corpo.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/mindfulness.jpeg',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Prática Diária 🧘",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• Acorde e medite por 5 minutos.\n• Observe seus pensamentos sem julgá-los.\n• Estabeleça gratidão diária por pequenas coisas.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
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
                          color: Colors.tealAccent,
                          size: 32,
                        ),
                        onPressed: tocarAudio,
                      ),
                      Expanded(
                        child: Slider(
                          value: 0.6,
                          onChanged: (value) {},
                          activeColor: Colors.tealAccent,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const Text(
                        "03:15",
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
