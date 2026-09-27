class ServiceModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final String duration;
  final String category;
  final bool isPopular;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    this.isPopular = false,
  });
}
