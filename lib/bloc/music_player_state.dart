part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerState extends Equatable {
  const MusicPlayerState();

  @override
  List<Object> get props => [];
}

class MusicPlayerInitial extends MusicPlayerState {}

class MusicPlayerLoading extends MusicPlayerState {}

class MusicPlayerLoaded extends MusicPlayerState {
  final List<SongInfo> songs;

  const MusicPlayerLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}

class MusicPlayerPlaying extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerPlaying({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}

class MusicPlayerPaused extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerPaused({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}

class MusicPlayerResume extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerResume({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}

class MusicPlayerError extends MusicPlayerState {
  final String message;

  const MusicPlayerError({required this.message});

  @override
  List<Object> get props => [message];
}

class MusicPlayerStopped extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerStopped({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}

class MusicPlayerSkipNext extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerSkipNext({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}

class MusicPlayerSkipPrev extends MusicPlayerState {
  final SongInfo song;
  final audio_player.AudioPlayer audioPlayer;

  const MusicPlayerSkipPrev({required this.song, required this.audioPlayer});

  @override
  List<Object> get props => [song, audioPlayer];
}
