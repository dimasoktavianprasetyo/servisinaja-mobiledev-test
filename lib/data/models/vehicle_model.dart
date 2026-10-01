class VehicleModel {
  final String id;
  final String name;
  final String plateNumber;
  final int odometerKm;
  final String lastService;
  final String conditionStatus;
  final bool isSelected;
  final String? _transmission;
  final String? _engineCc;
  final String? _year;
  final String? _color;
  final String? _chassisNumber;
  final String? _engineNumber;
  final String? _garageLabel;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.odometerKm,
    required this.lastService,
    this.conditionStatus = 'Kondisi OK',
    this.isSelected = false,
    String? transmission,
    String? engineCc,
    String? year,
    String? color,
    String? chassisNumber,
    String? engineNumber,
    String? garageLabel,
  })  : _transmission = transmission,
        _engineCc = engineCc,
        _year = year,
        _color = color,
        _chassisNumber = chassisNumber,
        _engineNumber = engineNumber,
        _garageLabel = garageLabel;

  String get transmission => _transmission ?? 'Matic (AT)';
  String get engineCc => _engineCc ?? '160cc';
  String get year => _year ?? '2024';
  String get color => _color ?? 'Hitam Doff';
  String get chassisNumber => _chassisNumber ?? 'MH1KF1144GH123456';
  String get engineNumber => _engineNumber ?? 'KF11E-100234';
  String get garageLabel => _garageLabel ?? 'Garasi Tambahan';

  VehicleModel copyWith({
    String? id,
    String? name,
    String? plateNumber,
    int? odometerKm,
    String? lastService,
    String? conditionStatus,
    bool? isSelected,
    String? transmission,
    String? engineCc,
    String? year,
    String? color,
    String? chassisNumber,
    String? engineNumber,
    String? garageLabel,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      odometerKm: odometerKm ?? this.odometerKm,
      lastService: lastService ?? this.lastService,
      conditionStatus: conditionStatus ?? this.conditionStatus,
      isSelected: isSelected ?? this.isSelected,
      transmission: transmission ?? this.transmission,
      engineCc: engineCc ?? this.engineCc,
      year: year ?? this.year,
      color: color ?? this.color,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      garageLabel: garageLabel ?? this.garageLabel,
    );
  }
}
