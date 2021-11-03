import 'package:flutter/foundation.dart';

@immutable
class MainBanner {
  final String name;
  final String imageUrl;
  final String slug;

  const MainBanner({
    required this.name,
    required this.imageUrl,
    required this.slug,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'slug': slug,
    };
  }

  factory MainBanner.fromJson(Map<String, dynamic> json) {
    return MainBanner(
      name: json['name'],
      imageUrl: json['imageUrl'],
      slug: json['slug'],
    );
  }

  @override
  String toString() =>
      'MainBanner(name: $name, imageUrl: $imageUrl, slug: $slug)';
}
