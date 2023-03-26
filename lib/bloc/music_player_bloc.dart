import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audio_player;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:meta/meta.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final FlutterAudioQuery _audioQuery = FlutterAudioQuery();
  final audio_player.AudioPlayer _audioPlayer = audio_player.AudioPlayer();
  late StreamSubscription<just_audio.PlaybackEvent> _playbackSubscription;

  MusicPlayerBloc() : super(MusicPlayerInitial()) {
    on<MusicPlayerEvent>((event, emit) async {
      if (event is LoadMusicFiles) {
        try {
          List<SongInfo> songs = await _audioQuery.getSongs();
          emit(MusicPlayerLoaded(songs: songs));
        } catch (e) {
          emit(MusicPlayerError(message: e.toString()));
        }
      } else if (event is PlayMusic) {
        String filePath = event.song.filePath;
        File file = File(filePath);
        if (await file.exists()) {
          await _audioPlayer.play(audio_player.DeviceFileSource(filePath));
          emit(MusicPlayerPlaying(song: event.song, audioPlayer: _audioPlayer));
        }
      } else if (event is PauseMusic) {
        if (state is MusicPlayerPlaying) {
          await _audioPlayer.pause();
          emit(MusicPlayerPaused(
              song: (state as MusicPlayerPlaying).song,
              audioPlayer: _audioPlayer));
        } else if (state is MusicPlayerResume) {
          await _audioPlayer.pause();
          emit(MusicPlayerPaused(
              song: (state as MusicPlayerResume).song,
              audioPlayer: _audioPlayer));
        }
      } else if (event is ResumeMusic) {
        if (state is MusicPlayerPaused) {
          await _audioPlayer.resume();
          emit(MusicPlayerResume(song: event.song, audioPlayer: _audioPlayer));
        }
      } else if (event is StopMusic) {
        if (state is MusicPlayerPaused || state is MusicPlayerPlaying) {
          try {
            await _audioPlayer.stop();
            List<SongInfo> songs = await _audioQuery.getSongs();
            emit(MusicPlayerLoaded(songs: songs));
          } catch (e) {
            emit(MusicPlayerError(message: e.toString()));
          }
        }
      } else if (event is SkipNextMusic) {
        if (state is MusicPlayerPaused || state is MusicPlayerPlaying) {
          try {
            var currentSongID = event.song.id;
            List<SongInfo> songs = await _audioQuery.getSongs();
            int indexCurrentSong =
                songs.indexWhere((element) => element.id == currentSongID);
            int indexNextSong = indexCurrentSong + 1;
            int a = songs.length;
            if (indexNextSong == songs.length) {
              indexNextSong = 0;
            }
            await _audioPlayer.stop();
            String filePath = songs[indexNextSong].filePath;
            File file = File(filePath);
            if (await file.exists()) {
              await _audioPlayer.play(audio_player.DeviceFileSource(filePath));
              emit(MusicPlayerPlaying(
                  song: songs[indexNextSong], audioPlayer: _audioPlayer));
            }
          } catch (e) {
            emit(MusicPlayerError(message: e.toString()));
          }
        }
      } else if (event is SkipPrevMusic) {
        if (state is MusicPlayerPaused || state is MusicPlayerPlaying) {
          try {
            var currentSongID = event.song.id;
            List<SongInfo> songs = await _audioQuery.getSongs();
            int indexCurrentSong =
                songs.indexWhere((element) => element.id == currentSongID);
            int indexNextSong = indexCurrentSong - 1;
            if (indexNextSong < 0) {
              indexNextSong = songs.length - 1;
            }
            await _audioPlayer.stop();
            String filePath = songs[indexNextSong].filePath;
            File file = File(filePath);
            if (await file.exists()) {
              await _audioPlayer.play(audio_player.DeviceFileSource(filePath));
              emit(MusicPlayerPlaying(
                  song: songs[indexNextSong], audioPlayer: _audioPlayer));
            }
          } catch (e) {
            emit(MusicPlayerError(message: e.toString()));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    _playbackSubscription.cancel();
    return super.close();
  }
}
