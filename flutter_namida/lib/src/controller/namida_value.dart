import 'package:flutter/material.dart';

import '../enums/player_state.dart';

@immutable
class NamidaValue {
  final PlayerState state;

  final Duration position;

  final Duration duration;

  final bool isFullscreen;

  final bool isMuted;

  final double speed;

  const NamidaValue({
    this.state = PlayerState.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isFullscreen = false,
    this.isMuted = false,
    this.speed = 1.0,
  });

  NamidaValue copyWith({
    PlayerState? state,
    Duration? position,
    Duration? duration,
    bool? isFullscreen,
    bool? isMuted,
    double? speed,
  }) {
    return NamidaValue(
      state: state ?? this.state,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isMuted: isMuted ?? this.isMuted,
      speed: speed ?? this.speed,
    );
  }
}
