import 'package:audioplayers/audioplayers.dart';
import 'package:basic_music_player/bloc/music_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingCard extends StatefulWidget {
  NowPlayingCard(
      {super.key,
      required this.song,
      required this.currentPositionLabel,
      required this.currentPosition,
      required this.maxDuration,
      required this.isPlaying,
      required this.maxDurationLabel,
      required this.audioPlayer});

  final SongInfo song;
  final String currentPositionLabel;
  late int currentPosition;
  final int maxDuration;
  final bool isPlaying;
  final String maxDurationLabel;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlayingCard> createState() => _NowPlayingCardState();
}

class _NowPlayingCardState extends State<NowPlayingCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.song.title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(widget.song.artist, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                "${widget.currentPositionLabel}/${widget.maxDurationLabel}",
                style: const TextStyle(fontSize: 25),
              ),
              Slider(
                value: double.parse(widget.currentPosition.toString()),
                min: 0,
                max: double.parse(widget.maxDuration.toString()),
                divisions: widget.maxDuration,
                label: widget.currentPositionLabel,
                onChanged: (double value) async {
                  int seekValue = value.round();
                  setState(() {
                    widget.currentPosition = seekValue;
                  });
                  await widget.audioPlayer
                      .seek(Duration(milliseconds: seekValue));
                },
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context
                          .read<MusicPlayerBloc>()
                          .add(SkipPrevMusic(widget.song));
                    },
                    child: const Icon(Icons.skip_previous),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.isPlaying) {
                        context.read<MusicPlayerBloc>().add(PauseMusic());
                      } else {
                        context
                            .read<MusicPlayerBloc>()
                            .add(ResumeMusic(widget.song));
                      }
                    },
                    child: widget.isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.read<MusicPlayerBloc>().add(StopMusic());
                    },
                    child: const Icon(Icons.stop),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context
                          .read<MusicPlayerBloc>()
                          .add(SkipNextMusic(widget.song));
                    },
                    child: const Icon(Icons.skip_next),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
