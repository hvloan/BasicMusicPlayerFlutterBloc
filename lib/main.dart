import 'package:basic_music_player/bloc/music_player_bloc.dart';
import 'package:basic_music_player/constants/request_permission.dart';
import 'package:basic_music_player/pages/music_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicPlayerBloc(),
      child: MaterialApp(
          title: 'Music Player',
          theme: ThemeData(primaryColor: Colors.blue),
          home: const MusicPlayerPage()),
    );
  }
}
