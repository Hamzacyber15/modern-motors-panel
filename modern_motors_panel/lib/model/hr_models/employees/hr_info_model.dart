// class HrInfoModel {
//   final String hrDesignationArabic;
//   final String hrDesignationEnglish;
//   final String hrDesignationId;
//   final double salary;
//   final double contractedSalary;
//   final double totalAllowances;

//   HrInfoModel({
//     required this.hrDesignationArabic,
//     required this.hrDesignationEnglish,
//     required this.hrDesignationId,
//     required this.salary,
//     required this.contractedSalary,
//     required this.totalAllowances,
//   });

//   factory HrInfoModel.fromMap(Map<String, dynamic> map) {
//     double cSalary = double.tryParse(map['contractedSalary'].toString()) ?? 0.0;
//     double salary = double.tryParse(map['salary'].toString()) ?? 0.0;
//     double tAllowances =
//         double.tryParse(map['totalAllowances'].toString()) ?? 0.0;
//     return HrInfoModel(
//         hrDesignationArabic: map['hrDesignationArabic'] ?? '',
//         hrDesignationEnglish: map['hrDesignationEnglish'] ?? '',
//         hrDesignationId: map['hrDesignationId'] ?? '',
//         salary: salary,
//         contractedSalary: cSalary,
//         totalAllowances: tAllowances);
//   }
// }

class HrInfoModel {
  final String hrDesignationArabic;
  final String hrDesignationEnglish;
  final String hrDesignationId;
  final double salary;
  final double contractedSalary;
  final double totalAllowances;

  HrInfoModel({
    required this.hrDesignationArabic,
    required this.hrDesignationEnglish,
    required this.hrDesignationId,
    required this.salary,
    required this.contractedSalary,
    required this.totalAllowances,
  });

  factory HrInfoModel.fromMap(Map<String, dynamic> map) {
    double cSalary = double.tryParse(map['contractedSalary'].toString()) ?? 0.0;
    double salary = double.tryParse(map['salary'].toString()) ?? 0.0;
    double tAllowances =
        double.tryParse(map['totalAllowances'].toString()) ?? 0.0;

    return HrInfoModel(
      hrDesignationArabic: map['hrDesignationArabic'] ?? '',
      hrDesignationEnglish: map['hrDesignationEnglish'] ?? '',
      hrDesignationId: map['hrDesignationId'] ?? '',
      salary: salary,
      contractedSalary: cSalary,
      totalAllowances: tAllowances,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hrDesignationId": hrDesignationId,
      "hrDesignationEnglish": hrDesignationEnglish,
      "hrDesignationArabic": hrDesignationArabic,
      "salary": salary,
      "contractedSalary": contractedSalary,
      "totalAllowances": totalAllowances,
    };
  }
}
