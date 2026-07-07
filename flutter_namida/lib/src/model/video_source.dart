import '../enums/source_type.dart';

class VideoSource {
  final String path;
  final SourceType type;
  final Map<String, String> httpHeaders;

  const VideoSource._({
    required this.path,
    required this.type,
    this.httpHeaders = const {},
  });

  const VideoSource.network(this.path, {this.httpHeaders = const {}})
    : type = SourceType.network;

  const VideoSource.asset(this.path)
    : type = SourceType.asset,
      httpHeaders = const {};

  const VideoSource.file(this.path)
    : type = SourceType.file,
      httpHeaders = const {};
}
