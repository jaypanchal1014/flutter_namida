import 'package:flutter/material.dart';
import 'package:flutter_namida/flutter_namida.dart';
import 'package:flutter_namida/src/widgets/control.dart';
import 'package:video_player/video_player.dart';

class NamidaPlayer extends StatefulWidget {
  final NamidaController controller;

  final VideoSource source;

  final bool autoPlay;

  final bool looping;

  final double aspectRatio;

  const NamidaPlayer({
    super.key,
    required this.controller,
    required this.source,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<NamidaPlayer> createState() => _NamidaPlayerState();
}

class _NamidaPlayerState extends State<NamidaPlayer> {
  @override
  void initState() {
    super.initState();

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await widget.controller.initialize(widget.source);

    await widget.controller.videoController?.setLooping(widget.looping);

    if (widget.autoPlay) {
      await widget.controller.play();
    }
  }

  @override
  void didUpdateWidget(covariant NamidaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.source.path != widget.source.path ||
        oldWidget.source.type != widget.source.type) {
      _initializePlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NamidaValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        switch (value.state) {
          case PlayerState.idle:
          case PlayerState.loading:
            return _buildLoading();

          case PlayerState.error:
            return _buildError();

          case PlayerState.playing:
          case PlayerState.paused:
          case PlayerState.completed:
            return _buildPlayer();
        }
      },
    );
  }

  Widget _buildPlayer() {
    final videoController = widget.controller.videoController;

    if (videoController == null || !videoController.value.isInitialized) {
      return _buildLoading();
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            VideoPlayer(videoController),
            NamidaControls(controller: widget.controller),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildError() {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Text(
            'Unable to load video',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
