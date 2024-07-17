import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:task2_advanced/play_song.dart';

class SongWidget extends StatefulWidget {
  const SongWidget({required this.audio, super.key});
  final Audio audio;

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  final List<Audio> playlist = [
    Audio(
      'assets/audios/1.mp3',
      metas: Metas(
        title: 'Song 1',
        image: const MetasImage.asset('assets/images/images.jpg'),
      ),
    ),
    Audio(
      'assets/audios/2.mp3',
      metas: Metas(
        title: 'Song 2',
        image: const MetasImage.asset('assets/images/images (2).jpg'),
      ),
    ),
    Audio(
      'assets/audios/3.mp3',
      metas: Metas(
        title: 'Song 3',
        image: const MetasImage.asset('assets/images/images (1).jpg'),
      ),
    ),
  ];

  @override
  void initState() {
    initSong();
    super.initState();
  }

  void initSong() async {
    await assetsAudioPlayer.open(widget.audio, autoStart: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return PlaySong(
                    audio: widget.audio,
                    songs: playlist,
                  );
                },
              ),
            );
          },
          trailing: StreamBuilder(
              stream: assetsAudioPlayer.realtimePlayingInfos,
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                }
                if (snapShot.data == null) {
                  return const SizedBox.shrink();
                }

                return Text(
                  convertToSeconds(snapShot.data?.duration.inSeconds ?? 0),
                  style: const TextStyle(color: Colors.white),
                );
              }),
          title: Text(
            widget.audio.metas.title ?? 'No title',
            style: const TextStyle(color: Colors.white),
          ),
          leading: Image.asset(
            "${widget.audio.metas.image?.path}",
            width: 70,
            height: 70,
          ),
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
