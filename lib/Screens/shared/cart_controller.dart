import 'package:flutter/material.dart';

import '../PurchaseSheets/shared/frame_product.dart';

class CartItem {
  final FrameProduct product;
  int qty;
  final String? imageUrl;

  CartItem({
    required this.product,
    this.qty = 1,
    this.imageUrl,
  });
}

class CartController extends ChangeNotifier {
  final Map<String, CartItem> _itemsById = {};

  List<CartItem> get items => _itemsById.values.toList(growable: false);

  bool get isEmpty => _itemsById.isEmpty;

  double get total {
    double sum = 0;
    for (final item in _itemsById.values) {
      sum += item.product.price * item.qty;
    }
    return sum;
  }

  void add(FrameProduct product, {int qty = 1, String? imageUrl}) {
    final existing = _itemsById[product.id];
    if (existing == null) {
      _itemsById[product.id] = CartItem(product: product, qty: qty, imageUrl: imageUrl);
    } else {
      existing.qty += qty;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _itemsById.remove(productId);
    notifyListeners();
  }

  void clear() {
    _itemsById.clear();
    notifyListeners();
  }
}

class CartScope extends InheritedNotifier<CartController> {
  CartScope({super.key, required Widget child})
      : super(notifier: CartController(), child: child);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope not found in widget tree');
    return scope!.notifier!;
  }
}
