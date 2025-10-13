class ProductUpdated {
  final String productId;
  final int quantityDeducted;
  final int stockAfter;
  final int stockBefore;

  ProductUpdated({
    required this.productId,
    required this.quantityDeducted,
    required this.stockAfter,
    required this.stockBefore,
  });

  factory ProductUpdated.fromMap(Map<String, dynamic> map) {
    return ProductUpdated(
      productId: map['productId'] ?? '',
      quantityDeducted: map['quantityDeducted'] ?? 0,
      stockAfter: map['stockAfter'] ?? 0,
      stockBefore: map['stockBefore'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantityDeducted': quantityDeducted,
      'stockAfter': stockAfter,
      'stockBefore': stockBefore,
    };
  }
}
