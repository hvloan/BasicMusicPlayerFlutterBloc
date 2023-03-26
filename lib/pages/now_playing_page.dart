import 'package:basic_music_player/bloc/music_player_bloc.dart';
import 'package:basic_music_player/widgets/now_playing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  int maxDuration = 100;
  int currentPosition = 0;
  String currentPositionLabel = "00:00";
  String maxDurationLabel = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = BlocProvider.of<MusicPlayerBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        musicPlayerBloc.add(LoadMusicFiles());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Now Playing'),
        ),
        body: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
          builder: (context, state) {
            if (state is MusicPlayerPlaying) {
              SongInfo song = state.song;
              state.audioPlayer.onPositionChanged.listen((Duration duration) {
                currentPosition = duration.inMilliseconds;
                int shours = Duration(milliseconds: currentPosition).inHours;
                int sminutes =
                    Duration(milliseconds: currentPosition).inMinutes;
                int sseconds =
                    Duration(milliseconds: currentPosition).inSeconds;
                int rhours = shours;
                int rminutes = sminutes - (shours * 60);
                int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
                setState(() {
                  currentPositionLabel = "$rhours:$rminutes:$rseconds";
                });
              });
              state.audioPlayer.onDurationChanged.listen((Duration duration) {
                maxDuration = duration.inMilliseconds;
                int shours = Duration(milliseconds: maxDuration).inHours;
                int sminutes = Duration(milliseconds: maxDuration).inMinutes;
                int sseconds = Duration(milliseconds: maxDuration).inSeconds;
                int rhours = shours;
                int rminutes = sminutes - (shours * 60);
                int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);
                setState(() {
                  maxDurationLabel = "$rhours:$rminutes:$rseconds";
                });
              });
              return NowPlayingCard(
                song: song,
                currentPositionLabel: currentPositionLabel,
                currentPosition: currentPosition,
                maxDuration: maxDuration,
                maxDurationLabel: maxDurationLabel,
                isPlaying: true,
                audioPlayer: state.audioPlayer,
              );
            } else if (state is MusicPlayerPaused) {
              SongInfo song = state.song;
              return NowPlayingCard(
                song: song,
                currentPositionLabel: currentPositionLabel,
                currentPosition: currentPosition,
                maxDuration: maxDuration,
                maxDurationLabel: maxDurationLabel,
                isPlaying: false,
                audioPlayer: state.audioPlayer,
              );
            } else if (state is MusicPlayerResume) {
              SongInfo song = state.song;
              return NowPlayingCard(
                song: song,
                currentPositionLabel: currentPositionLabel,
                currentPosition: currentPosition,
                maxDuration: maxDuration,
                maxDurationLabel: maxDurationLabel,
                isPlaying: true,
                audioPlayer: state.audioPlayer,
              );
            } else {
              return const Center(
                child: Text('No song is currently playing'),
              );
            }
          },
        ),
      ),
    );
  }
}
