import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class NotaViagem extends StatefulWidget {
  const NotaViagem({super.key});

  @override
  State<NotaViagem> createState() => _NotaViagemState();
}

class _NotaViagemState extends State<NotaViagem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void tocarAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
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
                    Icon(Icons.flight_takeoff, color: Colors.lightBlueAccent),
                    SizedBox(width: 8),
                    Text(
                      "Travel Notes",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
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
                        "Checklist de Viagem 🌍✈️",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.lightBlueAccent),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Documentos Importantes 📄",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• Passaporte ou RG\n• Cartões de crédito\n• Seguro viagem\n• Reservas de hotel\n• Ingressos de passeios",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/viagem.jpg',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Itens Pessoais 🎒",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• Roupas adequadas\n• Produtos de higiene\n• Remédios essenciais\n• Carregadores e adaptadores",
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
                          color: Colors.lightBlueAccent,
                          size: 32,
                        ),
                        onPressed: tocarAudio,
                      ),
                      Expanded(
                        child: Slider(
                          value: 0.5,
                          onChanged: (value) {},
                          activeColor: Colors.lightBlueAccent,
                          inactiveColor: Colors.white24,
                        ),
                      ),
                      const Text(
                        "01:42",
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
