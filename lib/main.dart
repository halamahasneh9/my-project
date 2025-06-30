import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const FairuzApp());

class FairuzApp extends StatelessWidget {
  const FairuzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FairuzHome(),
    );
  }
}

class FairuzHome extends StatefulWidget {
  const FairuzHome({super.key});

  @override
  State<FairuzHome> createState() => _FairuzHomeState();
}

class _FairuzHomeState extends State<FairuzHome>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  String? currentSong;
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  final List<String> songs = [
    'على بالي',
    'الي صار',
    'شاورت حالي',
    'بكتب اسمك',
    'تل الزعتر',
    'دق الهوا',
    'الله كبير',
    'سكن الليل',
    'مش حلو',
    'لشـو الحكي',
    'اقول لطفلتي',
    'دخيلك يا امي',
    'قديش كان',
    'نحنا و القمر',
    'كان الزمان',
    'جاءت معذبتي',
    'ايام الصيفيه',
    'ما بعرف',
    'امس انتهينا',
    'انا لحبيبي',
    'رجعت الصيفيه',
    'سألتك حبيبي',
    'سألوني الناس',
    'لمين',
    'يمكن',
    'ببالي',
    'بغير دني',
    'ما تزعل',
    'بيت صغير',
    'انا و اياك',
    'جسر اللوزيه',
  ];

  @override
  void initState() {
    super.initState();

    player.onDurationChanged.listen((d) {
      setState(() => totalDuration = d);
    });

    player.onPositionChanged.listen((p) {
      setState(() => currentPosition = p);
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void togglePlay(String song) async {
    if (currentSong == song && isPlaying) {
      await player.pause();
      setState(() => isPlaying = false);
    } else {
      await player.stop();
      await player.setSource(AssetSource('audio/$song.mp3'));
      await player.resume();
      setState(() {
        currentSong = song;
        isPlaying = true;
      });
    }
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final isSongPlaying = isPlaying && currentSong != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4E342E), Color(0xFF3E2723)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.music_note, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    "ألحان فيروز",
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: isSongPlaying ? 210 : 200,
                height: isSongPlaying ? 210 : 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade200,
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/fairous.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isThisPlaying = currentSong == song && isPlaying;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isThisPlaying
                              ? [Colors.amber.shade400, Colors.amber.shade200]
                              : [Colors.brown.shade400, Colors.brown.shade300],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.music_note, color: Colors.white),
                            title: Text(
                              song,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isThisPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => togglePlay(song),
                            ),
                          ),
                          if (isThisPlaying)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Color(0xFF4E342E),
                                      inactiveTrackColor: Color(0xFF6D4C41),
                                      thumbColor: Colors.amber,
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: totalDuration.inMilliseconds.toDouble(),
                                      value: currentPosition.inMilliseconds.clamp(0, totalDuration.inMilliseconds).toDouble(),
                                      onChanged: (value) {
                                        final newPos = Duration(milliseconds: value.toInt());
                                        player.seek(newPos);
                                        setState(() => currentPosition = newPos);
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatTime(currentPosition),
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                      Text(
                                        formatTime(totalDuration),
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}