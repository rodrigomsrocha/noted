import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class NotaEstudos extends StatefulWidget {
  @override
  _NotaEstudosState createState() => _NotaEstudosState();
}

class _NotaEstudosState extends State<NotaEstudos> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double sliderValue = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() => duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
        sliderValue = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0;
      });
    });
  }

  Future<void> tocarAudio() async {
    try {
      setState(() => isLoading = true);

      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        // First stop any current playback
        await _audioPlayer.stop();

        // Set the source first
        await _audioPlayer.setSource(
          UrlSource(
              'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3'),
        );

        // Then play it
        await _audioPlayer.resume();
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: ${e.toString()}')),
      );
    }
  }

  Future<void> seekAudio(double value) async {
    final newPosition =
        Duration(milliseconds: (value * duration.inMilliseconds).toInt());
    await _audioPlayer.seek(newPosition);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
                    Icon(Icons.menu_book, color: Colors.orangeAccent),
                    SizedBox(width: 8),
                    Text(
                      "Study Plan",
                      style: TextStyle(
                        color: Colors.orangeAccent,
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
                        "Plano de Estudos 📚📝",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Organização Semanal 📆",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Monte um cronograma simples para seus estudos:\n• Segunda: Matemática\n• Terça: História\n• Quarta: Biologia\n• Quinta: Física\n• Sexta: Revisão geral",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: isLoading
                                ? const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      color: Colors.orangeAccent,
                                    ),
                                  )
                                : Icon(
                                    isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.orangeAccent,
                                    size: 32,
                                  ),
                            onPressed: tocarAudio,
                          ),
                          Expanded(
                            child: Slider(
                              value: sliderValue,
                              onChanged: seekAudio,
                              activeColor: Colors.orangeAccent,
                              inactiveColor: Colors.white24,
                            ),
                          ),
                          Text(
                            formatDuration(position),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
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
