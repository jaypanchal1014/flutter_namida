import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/namida_controller.dart';
import '../controller/namida_value.dart';
import '../enums/player_state.dart';

class NamidaControls extends StatefulWidget {
  final NamidaController controller;

  const NamidaControls({super.key, required this.controller});

  @override
  State<NamidaControls> createState() => _NamidaControlsState();
}

class _NamidaControlsState extends State<NamidaControls> {
  bool _showControls = true;

  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();

    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _showControls = false;
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _showAndRestartTimer() {
    if (!_showControls) {
      setState(() {
        _showControls = true;
      });
    }

    _startHideTimer();
  }

  Future<void> _seekBackward(NamidaValue value) async {
    _showAndRestartTimer();

    final position = value.position - const Duration(seconds: 10);

    await widget.controller.seekTo(
      position < Duration.zero ? Duration.zero : position,
    );
  }

  Future<void> _seekForward(NamidaValue value) async {
    _showAndRestartTimer();

    final position = value.position + const Duration(seconds: 10);

    await widget.controller.seekTo(
      position > value.duration ? value.duration : position,
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NamidaValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        final isPlaying = value.state == PlayerState.playing;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () {
                        _seekBackward(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () {
                        _seekForward(value);
                      },
                    ),
                  ),
                ],
              ),
              IgnorePointer(
                ignoring: !_showControls,
                child: AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: ColoredBox(
                    color: Colors.black38,
                    child: Stack(
                      children: [
                        Center(
                          child: IconButton(
                            onPressed: () {
                              _showAndRestartTimer();

                              if (isPlaying) {
                                widget.controller.pause();
                              } else {
                                widget.controller.play();
                              }
                            },
                            iconSize: 64,
                            color: Colors.white,
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 8,
                          child: Row(
                            children: [
                              Text(
                                _formatDuration(value.position),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Slider(
                                  min: 0,
                                  max: _maxDuration(value),
                                  value: _position(value),
                                  onChanged: (sliderValue) {
                                    _showAndRestartTimer();

                                    widget.controller.seekTo(
                                      Duration(
                                        milliseconds: sliderValue.toInt(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDuration(value.duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showAndRestartTimer();

                                  if (value.isMuted) {
                                    widget.controller.unMute();
                                  } else {
                                    widget.controller.mute();
                                  }
                                },
                                color: Colors.white,
                                icon: Icon(
                                  value.isMuted
                                      ? Icons.volume_off
                                      : Icons.volume_up,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _maxDuration(NamidaValue value) {
    final duration = value.duration.inMilliseconds.toDouble();

    return duration <= 0 ? 1 : duration;
  }

  double _position(NamidaValue value) {
    final position = value.position.inMilliseconds.toDouble();

    final max = _maxDuration(value);

    return position.clamp(0, max).toDouble();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;

    final minutes = duration.inMinutes.remainder(60);

    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
