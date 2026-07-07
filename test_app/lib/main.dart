import 'package:flutter/material.dart';
import 'package:flutter_namida/flutter_namida.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const PlayerScreen(),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final NamidaController _controller;

  @override
  void initState() {
    super.initState();

    _controller = NamidaController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Namida Player')),
      body: Column(
        children: [
          NamidaPlayer(
            controller: _controller,
            source: const VideoSource.asset('assets/video/sample-30s.mp4'),
            autoPlay: false,
            looping: false,
          ),
        ],
      ),
    );
  }
}
