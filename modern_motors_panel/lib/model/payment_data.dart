class PaymentData {
  final bool isAlreadyPaid;
  final List<PaymentMethod> paymentMethods;
  final double remainingAmount;
  final double totalPaid;

  PaymentData({
    required this.isAlreadyPaid,
    required this.paymentMethods,
    required this.remainingAmount,
    required this.totalPaid,
  });

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    final paymentMethods = (map['paymentMethods'] as List<dynamic>? ?? [])
        .map((x) => PaymentMethod.fromMap(x as Map<String, dynamic>))
        .toList();

    return PaymentData(
      isAlreadyPaid: map['isAlreadyPaid'] ?? false,
      paymentMethods: paymentMethods,
      remainingAmount: (map['remainingAmount'] ?? 0).toDouble(),
      totalPaid: (map['totalPaid'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAlreadyPaid': isAlreadyPaid,
      'paymentMethods': paymentMethods.map((x) => x.toMap()).toList(),
      'remainingAmount': remainingAmount,
      'totalPaid': totalPaid,
    };
  }
}

class PaymentMethod {
  final double amount;
  final String method;
  final String methodName;
  final String reference;

  PaymentMethod({
    required this.amount,
    required this.method,
    required this.methodName,
    required this.reference,
  });

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      amount: (map['amount'] ?? 0).toDouble(),
      method: map['method'] ?? '',
      methodName: map['methodName'] ?? '',
      reference: map['reference'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'method': method,
      'methodName': methodName,
      'reference': reference,
    };
  }
}
