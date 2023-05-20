class Beverage {
  Beverage({
    required this.slug,
    required this.title,
    this.price,
    this.description,
    required this.primaryImage,
  });

  final String slug;
  final String title;
  final int? price;
  final Description? description;
  final PrimaryImage primaryImage;

  factory Beverage.fromJson(Map<String, dynamic> json) {
    return Beverage(
      slug: json['slug'],
      title: json['title'],
      price: json['price'],
      description: Description.fromJson(json['description']),
      primaryImage: PrimaryImage.fromJson(json['primaryImage']),
    );
  }
}

class Description {
  final String plaintext;

  Description({required this.plaintext});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      plaintext: json['plaintext'],
    );
  }
}

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
