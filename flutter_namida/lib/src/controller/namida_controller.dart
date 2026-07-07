import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_namida/flutter_namida.dart';
import 'package:video_player/video_player.dart';


class NamidaController extends ValueNotifier<NamidaValue> {
  NamidaController() : super(const NamidaValue());

  VideoPlayerController? _videoController;

  VideoPlayerController? get videoController => _videoController;

  bool _isDisposed = false;

  Future<void> initialize(VideoSource source) async {
    try {
      value = value.copyWith(
        state: PlayerState.loading,
        position: Duration.zero,
        duration: Duration.zero,
      );

      await _disposeVideoController();

      switch (source.type) {
        case SourceType.network:
          _videoController = VideoPlayerController.networkUrl(
            Uri.parse(source.path),
            httpHeaders: source.httpHeaders,
          );
          break;

        case SourceType.asset:
          _videoController = VideoPlayerController.asset(source.path);
          break;

        case SourceType.file:
          _videoController = VideoPlayerController.file(File(source.path));
          break;
      }

      await _videoController!.initialize();

      if (_isDisposed) {
        return;
      }

      _videoController!.addListener(_videoListener);

      value = value.copyWith(
        state: PlayerState.paused,
        duration: _videoController!.value.duration,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) {
        return;
      }

      value = value.copyWith(state: PlayerState.error);

      debugPrint('================ NAMIDA ERROR ================');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('================================================');
    }
  }

  void _videoListener() {
    if (_isDisposed) {
      return;
    }

    final controller = _videoController;

    if (controller == null) {
      return;
    }

    final videoValue = controller.value;

    PlayerState state;

    if (videoValue.hasError) {
      state = PlayerState.error;
    } else if (videoValue.isBuffering) {
      state = PlayerState.loading;
    } else if (videoValue.position >= videoValue.duration &&
        videoValue.duration > Duration.zero) {
      state = PlayerState.completed;
    } else if (videoValue.isPlaying) {
      state = PlayerState.playing;
    } else {
      state = PlayerState.paused;
    }

    value = value.copyWith(
      position: videoValue.position,
      duration: videoValue.duration,
      state: state,
    );
  }

  Future<void> play() async {
    await _videoController?.play();
  }

  Future<void> pause() async {
    await _videoController?.pause();
  }

  Future<void> stop() async {
    final controller = _videoController;

    if (controller == null) {
      return;
    }

    await controller.pause();

    await controller.seekTo(Duration.zero);
  }

  Future<void> seekTo(Duration position) async {
    await _videoController?.seekTo(position);
  }

  Future<void> setSpeed(double speed) async {
    await _videoController?.setPlaybackSpeed(speed);

    if (_isDisposed) {
      return;
    }

    value = value.copyWith(speed: speed);
  }

  Future<void> mute() async {
    await _videoController?.setVolume(0);

    if (_isDisposed) {
      return;
    }

    value = value.copyWith(isMuted: true);
  }

  Future<void> unMute() async {
    await _videoController?.setVolume(1);

    if (_isDisposed) {
      return;
    }

    value = value.copyWith(isMuted: false);
  }

  Future<void> enterFullscreen() async {
    if (_isDisposed) {
      return;
    }

    value = value.copyWith(isFullscreen: true);
  }

  Future<void> exitFullscreen() async {
    if (_isDisposed) {
      return;
    }

    value = value.copyWith(isFullscreen: false);
  }

  Future<void> _disposeVideoController() async {
    final controller = _videoController;

    if (controller == null) {
      return;
    }

    controller.removeListener(_videoListener);

    await controller.dispose();

    _videoController = null;
  }

  @override
  void dispose() {
    _isDisposed = true;

    final controller = _videoController;

    if (controller != null) {
      controller.removeListener(_videoListener);

      controller.dispose();
    }

    _videoController = null;

    super.dispose();
  }
}
