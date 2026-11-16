import 'package:flutter/foundation.dart';
import 'cart_model.dart';

class OrderItem {
  final String orderId;
  final List<CartItem> items;
  final double totalAmount;
  final String name;
  final String phone;
  final String address;
  final String paymentMethod;
  final DateTime date;
  String status;

  OrderItem({
    required this.orderId,
    required this.items,
    required this.totalAmount,
    required this.name,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.date,
    this.status = 'Pending',
  });
}

class OrderHistoryModel extends ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => List.unmodifiable(_orders);

  void addOrder(OrderItem order) {
    _orders.insert(0, order); // latest first
    notifyListeners();
  }
}

final OrderHistoryModel orderHistory = OrderHistoryModel();
