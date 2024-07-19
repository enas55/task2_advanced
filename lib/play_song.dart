import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlaySong extends StatefulWidget {
  const PlaySong({required this.audio, super.key, required this.songs});
  final List<Audio> songs;
  final Audio audio;

  @override
  State<PlaySong> createState() => _PlaySongState();
}

class _PlaySongState extends State<PlaySong> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  late int currentIndex;
  int valueEx = 0;
  int durationEx = 0;

  @override
  void initState() {
    currentIndex = widget.songs.indexOf(widget.audio);
    initSong();

    super.initState();
  }

  // void initSong() async {
  //   await assetsAudioPlayer.open(
  //     widget.songs[currentIndex],
  //     autoStart: false,
  //   );
  //   assetsAudioPlayer.currentPosition.listen((event) {
  //     valueEx = event.inSeconds;
  //     setState(() {});
  //   });
  //   assetsAudioPlayer.current.listen(
  //     (event) {
  //       if (event != null) {
  //         durationEx = event.audio.duration.inSeconds;
  //         setState(() {});
  //       }
  //     },
  //   );

  //   setState(() {});
  // }

  void initSong() async {
    await assetsAudioPlayer.open(
      widget.songs[currentIndex],
      autoStart: false,
    );
    assetsAudioPlayer.currentPosition.listen((event) {
      if (mounted) {
        valueEx = event.inSeconds;
        setState(() {});
      }
    });
    assetsAudioPlayer.current.listen(
      (event) {
        if (event != null && mounted) {
          durationEx = event.audio.duration.inSeconds;
          setState(() {});
        }
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text(
          '${widget.songs[currentIndex].metas.title}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.songs[currentIndex].metas.image?.path ?? 'No Image',
              width: 400,
              height: 400,
            ),
            Slider(
              activeColor: Colors.teal,
              value: valueEx.toDouble(),
              min: 0,
              max: durationEx.toDouble(),
              onChanged: (value) async {
                valueEx = value.toInt();
                setState(() {});
              },
              onChangeEnd: (value) async {
                await assetsAudioPlayer.seek(
                  Duration(
                    seconds: value.toInt(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(convertToSeconds(valueEx)),
                  Text(convertToSeconds(durationEx)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (currentIndex > 0) {
                      currentIndex--;
                    } else {
                      currentIndex = widget.songs.length - 1;
                    }
                    assetsAudioPlayer.open(widget.songs[currentIndex],
                        autoStart: true);
                    isPlaying = true;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.teal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      assetsAudioPlayer.pause();
                    } else {
                      assetsAudioPlayer.play();
                    }
                    isPlaying = !isPlaying;
                    setState(() {});
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.teal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (currentIndex < widget.songs.length - 1) {
                      currentIndex++;
                    } else {
                      currentIndex = 0;
                    }
                    assetsAudioPlayer.open(widget.songs[currentIndex],
                        autoStart: true);
                    isPlaying = true;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String convertToSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondStr.padLeft(2, '0')}';
  }
}
