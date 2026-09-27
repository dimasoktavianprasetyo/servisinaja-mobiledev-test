class PromoVoucherModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final String discountTag;
  final String validUntil;
  final bool isMultiMotor;

  const PromoVoucherModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountTag,
    required this.validUntil,
    this.isMultiMotor = false,
  });
}
