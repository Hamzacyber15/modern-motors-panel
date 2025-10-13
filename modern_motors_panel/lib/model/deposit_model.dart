class Deposit {
  final bool depositAlreadyPaid;
  final double depositAmount;
  final double depositPercentage;
  final String depositType;
  final double nextPaymentAmount;
  final bool requireDeposit;
  final double depositA;

  Deposit({
    required this.depositAlreadyPaid,
    required this.depositAmount,
    required this.depositPercentage,
    required this.depositType,
    required this.nextPaymentAmount,
    required this.requireDeposit,
    required this.depositA,
  });

  factory Deposit.fromMap(Map<String, dynamic> map) {
    return Deposit(
      depositAlreadyPaid: map['depositAlreadyPaid'] ?? false,
      depositAmount: (map['depositAmount'] ?? 0).toDouble(),
      depositPercentage: (map['depositPercentage'] ?? 0).toDouble(),
      depositType: map['depositType'] ?? 'percentage',
      nextPaymentAmount: (map['nextPaymentAmount'] ?? 0).toDouble(),
      requireDeposit: map['requireDeposit'] ?? false,
      depositA: (map['depositA'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'depositAlreadyPaid': depositAlreadyPaid,
      'depositAmount': depositAmount,
      'depositPercentage': depositPercentage,
      'depositType': depositType,
      'nextPaymentAmount': nextPaymentAmount,
      'requireDeposit': requireDeposit,
      'depositA': depositA,
    };
  }
}
