import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

export '../../models/seller_product.dart';

import '../../models/seller_product.dart';
import '../../db/seller_product_repo.dart' as db;
import '../../db/seller_product_cloud_repo.dart' as cloud;

class ProductController extends ChangeNotifier {
  final List<SellerProduct> _products = [];

  final db.SellerProductRepo _repo;
  final cloud.SellerProductCloudRepo _cloudRepo;
  bool _loadedFromDb = false;

  ProductController({
    db.SellerProductRepo? repo,
    cloud.SellerProductCloudRepo? cloudRepo,
  })  : _repo = repo ?? db.SellerProductRepo(),
        _cloudRepo = cloudRepo ?? const cloud.SellerProductCloudRepo() {
    _loadFromDb();
    _syncFromCloud();
  }

  /// Get current user ID
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  List<SellerProduct> get all => List.unmodifiable(_products);

  /// Get only products created by the current logged-in seller
  List<SellerProduct> get mySellerProducts {
    final uid = currentUserId;
    if (uid == null) return [];
    return _products.where((p) => p.sellerId == uid).toList();
  }

  bool get loadedFromDb => _loadedFromDb;

  Future<void> _loadFromDb() async {
    try {
      final items = await _repo.listAll();
      _products
        ..clear()
        ..addAll(items);
    } finally {
      _loadedFromDb = true;
      notifyListeners();
    }
  }

  Future<void> _syncFromCloud() async {
    try {
      // Sync ALL products from cloud (so buyers can see all sellers' products)
      final remote = await _cloudRepo.listAll();
      if (remote.isEmpty) return;

      // Persist remote items locally so they remain available offline.
      for (final p in remote) {
        if (p.product.id.isEmpty) continue;
        await _repo.upsert(p);
      }

      // Merge into in-memory list.
      for (final p in remote) {
        if (p.product.id.isEmpty) continue;
        final idx = _products.indexWhere((x) => x.product.id == p.product.id);
        if (idx == -1) {
          _products.insert(0, p);
        } else {
          _products[idx] = p;
        }
      }
    } catch (_) {
      // Cloud sync is best-effort; local DB remains source of offline truth.
    } finally {
      notifyListeners();
    }
  }

  void add(SellerProduct p) {
    _products.insert(0, p);
    notifyListeners();
  }

  Future<void> addAndPersist(SellerProduct p) async {
    // Add sellerId if not present
    final productWithSeller = p.sellerId == null && currentUserId != null
        ? p.copyWithSellerId(currentUserId)
        : p;
    
    add(productWithSeller);
    await _repo.upsert(productWithSeller);
    try {
      await _cloudRepo.upsert(productWithSeller);
    } catch (_) {
      // Ignore cloud failures; product is still saved locally.
    }
  }

  void update(SellerProduct p) {
    final idx = _products.indexWhere((x) => x.product.id == p.product.id);
    if (idx == -1) {
      add(p);
      return;
    }
    _products[idx] = p;
    notifyListeners();
  }

  Future<void> updateAndPersist(SellerProduct p) async {
    // Ensure sellerId is preserved
    final productWithSeller = p.sellerId == null && currentUserId != null
        ? p.copyWithSellerId(currentUserId)
        : p;
    
    update(productWithSeller);
    await _repo.upsert(productWithSeller);
    try {
      await _cloudRepo.upsert(productWithSeller);
    } catch (_) {
      // Ignore cloud failures; product is still saved locally.
    }
  }

  void removeById(String id) {
    _products.removeWhere((p) => p.product.id == id);
    notifyListeners();
  }

  Future<void> removeByIdAndPersist(String id) async {
    removeById(id);
    await _repo.deleteById(id);
    try {
      await _cloudRepo.deleteById(id);
    } catch (_) {
      // Ignore cloud failures; product is still removed locally.
    }
  }

  /// Filter products for the current seller only
  List<SellerProduct> filterMyProducts({
    required ProductCategory category,
    required Audience audience,
    required String shape,
  }) {
    final uid = currentUserId;
    return _products
        .where((p) =>
            p.sellerId == uid &&
            p.category == category &&
            p.audience == audience &&
            p.product.shape.toLowerCase() == shape.toLowerCase())
        .toList(growable: false);
  }

  /// Filter all products (for buyers)
  List<SellerProduct> filter({
    required ProductCategory category,
    required Audience audience,
    required String shape,
  }) {
    return _products
        .where((p) =>
            p.category == category &&
            p.audience == audience &&
            p.product.shape.toLowerCase() == shape.toLowerCase())
        .toList(growable: false);
  }
}

class ProductScope extends InheritedNotifier<ProductController> {
  ProductScope({super.key, required Widget child})
  : super(notifier: ProductController(), child: child);

  static ProductController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProductScope>();
    assert(scope != null, 'ProductScope not found in widget tree');
    return scope!.notifier!;
  }
}
