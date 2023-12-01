class Order {
  int? orderId;
  String? memberNIM;
  String? workerNIP;
  String? bookId;
  DateTime? orderTime;
  DateTime? returnTime;

  Order({
    this.orderId,
    this.memberNIM,
    this.workerNIP,
    this.bookId,
    this.orderTime,
    this.returnTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberNIM': memberNIM,
      'workerNIP': workerNIP,
      'bookId': bookId,
      'orderTime': orderTime?.toIso8601String(),
      'returnTime': returnTime?.toIso8601String(),
    };
  }
}
