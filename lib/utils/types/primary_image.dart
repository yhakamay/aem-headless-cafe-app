class PrimaryImage {
  final String path;
  final String mimeType;
  final int width;
  final int height;

  PrimaryImage(
      {required this.path,
      required this.mimeType,
      required this.width,
      required this.height});

  factory PrimaryImage.fromJson(Map<String, dynamic> json) {
    return PrimaryImage(
      path: json['_path'],
      mimeType: json['mimeType'],
      width: json['width'],
      height: json['height'],
    );
  }
}
