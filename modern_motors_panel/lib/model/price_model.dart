class PriceModel {
  String id;
  double price;
  String status;
  String duration;
  DateTime createdAt;
  String? orderBasis;
  DateTime? time;
  DateTime? endTime;
  bool? applyDiscount;
  PriceModel({
    required this.id,
    required this.price,
    required this.status,
    required this.duration,
    required this.createdAt,
    this.orderBasis,
    this.time,
    this.endTime,
    this.applyDiscount,
  });
}
