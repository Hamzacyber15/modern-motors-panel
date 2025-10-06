class AssignedEquipmentModel {
  String equipmentId;
  String equipmentNumber;
  String equipmentType;
  AssignedEquipmentModel({
    required this.equipmentId,
    required this.equipmentNumber,
    required this.equipmentType,
  });
  factory AssignedEquipmentModel.fromMap(Map<String, dynamic> map) {
    return AssignedEquipmentModel(
      equipmentId: map["equipmentId"] ?? "",
      equipmentNumber: map['equipmentNumber'] ?? "",
      equipmentType: map['equipmentType'] ?? "",
    );
  }
}
