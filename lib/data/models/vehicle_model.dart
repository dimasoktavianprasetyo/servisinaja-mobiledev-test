class VehicleModel {
  final String id;
  final String name;
  final String plateNumber;
  final int odometerKm;
  final String lastService;
  final String conditionStatus;
  final bool isSelected;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.odometerKm,
    required this.lastService,
    this.conditionStatus = 'Kondisi OK',
    this.isSelected = false,
  });

  VehicleModel copyWith({
    String? id,
    String? name,
    String? plateNumber,
    int? odometerKm,
    String? lastService,
    String? conditionStatus,
    bool? isSelected,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      odometerKm: odometerKm ?? this.odometerKm,
      lastService: lastService ?? this.lastService,
      conditionStatus: conditionStatus ?? this.conditionStatus,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
