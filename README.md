# Flutter Namida Player

A lightweight, reusable, and customizable video player package for Flutter.

`flutter_namida_player` provides a simple controller-based API for playing network, asset, and local video files with custom controls, seeking, playback speed, mute support, auto-hide controls, and double-tap seeking.

Built on top of Flutter's `video_player` package with a clean and developer-friendly API.

---

## ✨ Features

- 🎥 Network video playback
- 📦 Asset video playback
- 📁 Local file video playback
- ▶️ Play and pause controls
- ⏹ Stop video playback
- ⏩ Seek to any video position
- ⚡ Playback speed control
- 🔇 Mute and unmute support
- ⏱ Current position and video duration
- 👆 Single tap to show or hide controls
- ⏪ Double tap left to seek backward 10 seconds
- ⏩ Double tap right to seek forward 10 seconds
- 🫥 Auto-hide controls
- 🔄 Looping support
- 🚀 Auto play support
- 🌐 HTTP headers support
- ⏳ Loading state
- ❌ Error state
- 🎮 Controller-based API
- ⚡ Lightweight and reusable

---

## 📦 Installation

Add `flutter_namida_player` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_namida: path: ../
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Getting Started

Import the package:

```dart
import 'package:flutter_namida_player/flutter_namida_player.dart';
```

Create a `NamidaController`:

```dart
late final NamidaController controller;

@override
void initState() {
  super.initState();

  controller = NamidaController();
}
```

Dispose the controller when it is no longer needed:

```dart
@override
void dispose() {
  controller.dispose();

  super.dispose();
}
```

---

## 🎥 Basic Usage

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.network(
    'https://example.com/video.mp4',
  ),
)
```

The player automatically initializes the video source.

You do not need to manually call `initialize()`.

---

## 🌐 Network Video

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.network(
    'https://example.com/video.mp4',
  ),
)
```

For Android network playback, make sure your application has internet permission.

Add this to:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 📦 Asset Video

Add your video asset to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/videos/video.mp4
```

Use the asset source:

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.asset(
    'assets/videos/video.mp4',
  ),
)
```

---

## 📁 Local File Video

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.file(
    '/storage/emulated/0/video.mp4',
  ),
)
```

---

## 🌐 HTTP Headers

Protected or authenticated video URLs can use custom HTTP headers.

```dart
NamidaPlayer(
  controller: controller,
  source: VideoSource.network(
    'https://example.com/video.mp4',
    httpHeaders: {
      'Authorization': 'Bearer your_token',
      'User-Agent': 'NamidaPlayer',
    },
  ),
)
```

---

## ▶️ Play Video

```dart
controller.play();
```

---

## ⏸ Pause Video

```dart
controller.pause();
```

---

## ⏹ Stop Video

```dart
controller.stop();
```

Stopping the video pauses playback and seeks back to the beginning.

---

## 🔇 Mute Video

```dart
controller.mute();
```

---

## 🔊 Unmute Video

```dart
controller.unMute();
```

---

## 🔄 Loop Video

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.asset(
    'assets/videos/video.mp4',
  ),
  looping: true,
)
```

---

## 🚀 Auto Play

```dart
NamidaPlayer(
  controller: controller,
  source: const VideoSource.asset(
    'assets/videos/video.mp4',
  ),
  autoPlay: true,
)
```

---
## ⏪ Double Tap Seek

Double tap the left side of the player to seek backward:

```text
-10 seconds
```

Double tap the right side of the player to seek forward:

```text
+10 seconds
```

---

## 💻 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_namida/flutter_namida.dart';


void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayerScreen(),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
  });

  @override
  State<PlayerScreen> createState() {
    return _PlayerScreenState();
  }
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final NamidaController controller;

  @override
  void initState() {
    super.initState();

    controller = NamidaController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Namida Player',
        ),
      ),
      body: NamidaPlayer(
        controller: controller,
        source: const VideoSource.asset(
          'assets/videos/video.mp4',
        ),
        autoPlay: false,
        looping: false,
      ),
    );
  }
}
```

---

## 🏗 Package Architecture

```text
lib/
│
├── flutter_namida_player.dart
│
└── src/
    │
    ├── controller/
    │   ├── namida_controller.dart
    │   └── namida_value.dart
    │
    ├── enums/
    │   ├── player_state.dart
    │   └── source_type.dart
    │
    ├── models/
    │   └── video_source.dart
    │
    └── widgets/
        ├── namida_player.dart
        └── controls.dart
```

---

## 📄 License

MIT License
 
Copyright (c) 2026 Excelsior Technologies
 
Permission is hereby granted, free of charge, to any person obtaining a copy

of this software and associated documentation files (the "Software"), to deal

in the Software without restriction, including without limitation the rights

to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

copies of the Software, and to permit persons to whom the Software is

furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all

copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE

AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER

LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,

OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

SOFTWARE.
 

