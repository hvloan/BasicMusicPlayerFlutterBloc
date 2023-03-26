import 'package:basic_music_player/bloc/music_player_bloc.dart';
import 'package:basic_music_player/pages/now_playing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<MusicPlayerBloc>().add(LoadMusicFiles());
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          if (state is MusicPlayerLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MusicPlayerLoaded) {
            return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                SongInfo song = state.songs[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () {
                    context.read<MusicPlayerBloc>().add(PlayMusic(song: song));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NowPlayingPage(),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is MusicPlayerError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('No music files found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MusicPlayerBloc>().add(LoadMusicFiles());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
