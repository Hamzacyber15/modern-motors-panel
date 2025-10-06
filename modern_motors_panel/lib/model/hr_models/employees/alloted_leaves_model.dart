// class AllotedLeavesModel {
//   final String? leaveID;
//   final double leaveNumber;
//   final String leaveTypeArabic;
//   final String leaveTypeEnglish;
//   final double leaveBalance;

//   AllotedLeavesModel({
//     this.leaveID,
//     required this.leaveNumber,
//     required this.leaveTypeArabic,
//     required this.leaveTypeEnglish,
//     required this.leaveBalance,
//   });

//   factory AllotedLeavesModel.fromMap(Map<String, dynamic> map) {
//     double lN = double.tryParse(map['leaveNumber'].toString()) ?? 0;
//     double lB = double.tryParse(map['leaveBalance'].toString()) ?? 0;
//     return AllotedLeavesModel(
//       leaveID: map['leaveID'],
//       leaveNumber: lN,
//       leaveTypeArabic: map['leaveTypeArabic'] ?? '',
//       leaveTypeEnglish: map['leaveTypeEnglish'] ?? '',
//       leaveBalance: lB,
//     );
//   }
// }

class AllotedLeavesModel {
  final String? leaveID;
  final double leaveNumber;
  final String leaveTypeArabic;
  final String leaveTypeEnglish;
  final double leaveBalance;

  AllotedLeavesModel({
    this.leaveID,
    required this.leaveNumber,
    required this.leaveTypeArabic,
    required this.leaveTypeEnglish,
    required this.leaveBalance,
  });

  factory AllotedLeavesModel.fromMap(Map<String, dynamic> map) {
    double lN = double.tryParse(map['leaveNumber'].toString()) ?? 0;
    double lB = double.tryParse(map['leaveBalance'].toString()) ?? 0;
    return AllotedLeavesModel(
      leaveID: map['leaveID'],
      leaveNumber: lN,
      leaveTypeArabic: map['leaveTypeArabic'] ?? '',
      leaveTypeEnglish: map['leaveTypeEnglish'] ?? '',
      leaveBalance: lB,
    );
  }

  Map<String, dynamic> toMapForAdd() {
    return {
      'leaveID': leaveID,
      'leaveNumber': leaveNumber,
      'leaveTypeArabic': leaveTypeArabic,
      'leaveTypeEnglish': leaveTypeEnglish,
      'leaveBalance': leaveBalance,
    };
  }

  Map<String, dynamic> toMapForUpdate() {
    return {
      'leaveID': leaveID,
      'leaveNumber': leaveNumber,
      'leaveTypeArabic': leaveTypeArabic,
      'leaveTypeEnglish': leaveTypeEnglish,
      'leaveBalance': leaveBalance,
    };
  }
}
