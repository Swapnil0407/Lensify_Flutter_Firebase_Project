import 'package:flutter/material.dart';

class WishlistController extends ChangeNotifier {
  final Map<String, WishlistItem> _wishlistItems = {};

  List<WishlistItem> get items => _wishlistItems.values.toList();

  bool isWishlisted(String productId) {
    return _wishlistItems.containsKey(productId);
  }

  void addToWishlist(WishlistItem item) {
    if (!_wishlistItems.containsKey(item.productId)) {
      _wishlistItems[item.productId] = item;
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
      notifyListeners();
    }
  }

  void toggleWishlist(WishlistItem item) {
    if (isWishlisted(item.productId)) {
      removeFromWishlist(item.productId);
    } else {
      addToWishlist(item);
    }
  }

  int get count => _wishlistItems.length;
}

class WishlistItem {
  final String productId;
  final String title;
  final String imageAsset;
  final String? imageUrl;
  final double price;
  final String shape;
  final String frameWidth;

  WishlistItem({
    required this.productId,
    required this.title,
    required this.imageAsset,
    this.imageUrl,
    required this.price,
    required this.shape,
    this.frameWidth = 'Medium',
  });
}

class WishlistScope extends InheritedWidget {
  final WishlistController controller;

  const WishlistScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static WishlistController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WishlistScope>();
    if (scope == null) {
      throw Exception('WishlistScope not found in widget tree');
    }
    return scope.controller;
  }

  static WishlistController? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<WishlistScope>();
    return scope?.controller;
  }

  @override
  bool updateShouldNotify(WishlistScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
