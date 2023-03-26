part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent extends Equatable {}

class LoadMusicFiles extends MusicPlayerEvent {
  @override
  List<Object> get props => [];
}

class PlayMusic extends MusicPlayerEvent {
  final SongInfo song;

  PlayMusic({required this.song});

  @override
  List<Object> get props => [song];
}

class PauseMusic extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class ResumeMusic extends MusicPlayerEvent {
  final SongInfo song;

  ResumeMusic(this.song);

  @override
  List<Object?> get props => [];
}

class StopMusic extends MusicPlayerEvent {
  @override
  List<Object?> get props => [];
}

class SkipNextMusic extends MusicPlayerEvent {
  final SongInfo song;

  SkipNextMusic(this.song);

  @override
  List<Object?> get props => [];
}

class SkipPrevMusic extends MusicPlayerEvent {
  final SongInfo song;

  SkipPrevMusic(this.song);

  @override
  List<Object?> get props => [];
}
