import 'description.dart';
import 'primary_image.dart';

class Food {
  Food({
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

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      slug: json['slug'],
      title: json['title'],
      price: json['price'],
      description: Description.fromJson(json['description']),
      primaryImage: PrimaryImage.fromJson(json['primaryImage']),
    );
  }
}
