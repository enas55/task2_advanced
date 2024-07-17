import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:task2_advanced/song_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(Playlist(audios: playlist), autoStart: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Playlist Player',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            return SongWidget(audio: playlist[index]);

            // Card(
            //   color: Colors.teal,
            //   child: ListTile(
            //     title: Text(
            //       assetsAudioPlayer.playlist?.audios[index].metas.title ??
            //           'No title',
            //       style: const TextStyle(color: Colors.white),
            //     ),
            //     leading: Image.asset(
            //       "${assetsAudioPlayer.playlist?.audios[index].metas.image?.path}",
            //       width: 50,
            //       height: 40,
            //     ),
            //     trailing: StreamBuilder(
            //         stream: assetsAudioPlayer.currentPosition,
            //         builder: (context, snapShot) {
            //           if (!snapShot.hasData || snapShot.data == null) {
            //             return const Text('00:00 / 00:00');
            //           }
            //           return Text(convertToSeconds(snapShot.data!.inSeconds));
            //         }),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
