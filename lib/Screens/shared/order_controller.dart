import 'package:flutter/material.dart';
import 'package:lensify/Screens/PurchaseSheets/shared/frame_product.dart';

class OrderItem {
  final String id;
  final String title;
  final double price;
  final int qty;
  final String paymentMethod;
  final bool isPaid;
  final String? imageUrl;
  final String assetFallback;
  final DateTime orderedAt;
  final DateTime eta;
  final DateTime? deliveredAt;

  const OrderItem({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    required this.paymentMethod,
    required this.isPaid,
    required this.orderedAt,
    required this.eta,
    this.imageUrl,
    required this.assetFallback,
    this.deliveredAt,
  });

  bool get isDelivered => deliveredAt != null || DateTime.now().isAfter(eta);

  DateTime? get deliveredOn => deliveredAt ?? (isDelivered ? eta : null);
}

class OrderController extends ChangeNotifier {
  final List<OrderItem> _orders = [];
  int _seq = 0;

  List<OrderItem> get orders => List.unmodifiable(_orders);

  void placeOrder(
    FrameProduct product, {
    String? imageUrl,
    int qty = 1,
    String paymentMethod = 'Cash on Delivery',
    bool? isPaid,
    Duration eta = const Duration(days: 3),
  }) {
    final now = DateTime.now();
    final id = _nextId(now);

    final paid = isPaid ?? (paymentMethod != 'Cash on Delivery');

    _orders.insert(
      0,
      OrderItem(
        id: id,
        title: product.title,
        price: product.price,
        qty: qty < 1 ? 1 : qty,
        paymentMethod: paymentMethod,
        isPaid: paid,
        imageUrl: imageUrl,
        assetFallback: product.imageAsset,
        orderedAt: now,
        eta: now.add(eta),
      ),
    );

    notifyListeners();
  }

  String _nextId(DateTime now) {
    _seq += 1;
    final stamp = now.millisecondsSinceEpoch.toString();
    return 'OD$stamp$_seq';
  }
}

class OrderScope extends InheritedNotifier<OrderController> {
  OrderScope({
    super.key,
    required Widget child,
  }) : super(notifier: OrderController(), child: child);

  static OrderController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<OrderScope>();
    assert(scope != null, 'No OrderScope found in context');
    return scope!.notifier!;
  }
}
