import 'package:cloud_firestore/cloud_firestore.dart';

import '../Screens/PurchaseSheets/shared/frame_product.dart';
import '../models/seller_product.dart';

class SellerProductCloudRepo {
  const SellerProductCloudRepo();

  CollectionReference<Map<String, Object?>> get _col =>
      FirebaseFirestore.instance.collection('seller_products');

  Map<String, Object?> _toDoc(SellerProduct p) {
    return {
      'id': p.product.id,
      'title': p.product.title,
      'description': p.product.description,
      'imageAsset': p.product.imageAsset,
      'imageUrl': p.imageUrl,
      'category': p.category.name,
      'audience': p.audience.name,
      'shape': p.product.shape,
      'price': p.product.price,
      'mrp': p.product.mrp,
      'sellerId': p.sellerId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SellerProduct _fromDoc(Map<String, Object?> r) {
    final product = FrameProduct(
      id: (r['id'] as String?) ?? '',
      title: (r['title'] as String?) ?? '',
      shape: (r['shape'] as String?) ?? '',
      price: (r['price'] as num?)?.toDouble() ?? 0,
      mrp: (r['mrp'] as num?)?.toDouble(),
      imageAsset: (r['imageAsset'] as String?) ?? 'assets/images/eyeMen.jpg',
      description: (r['description'] as String?) ?? '',
    );

    final categoryName = (r['category'] as String?) ?? ProductCategory.eyeglasses.name;
    final audienceName = (r['audience'] as String?) ?? Audience.men.name;

    return SellerProduct(
      product: product,
      category: ProductCategory.values.byName(categoryName),
      audience: Audience.values.byName(audienceName),
      imageUrl: r['imageUrl'] as String?,
      sellerId: r['sellerId'] as String?,
    );
  }

  Future<void> upsert(SellerProduct p) async {
    await _col.doc(p.product.id).set(_toDoc(p), SetOptions(merge: true));
  }

  Future<void> deleteById(String id) async {
    await _col.doc(id).delete();
  }

  /// List all products (for buyers to see all available products)
  Future<List<SellerProduct>> listAll() async {
    final snap = await _col.get();
    final out = <SellerProduct>[];

    for (final d in snap.docs) {
      final data = d.data();
      data['id'] ??= d.id;
      try {
        out.add(_fromDoc(data));
      } catch (_) {
        // Ignore bad docs rather than crashing the whole list.
      }
    }

    return out;
  }

  /// List products for a specific seller only
  Future<List<SellerProduct>> listBySellerId(String sellerId) async {
    final snap = await _col.where('sellerId', isEqualTo: sellerId).get();
    final out = <SellerProduct>[];

    for (final d in snap.docs) {
      final data = d.data();
      data['id'] ??= d.id;
      try {
        out.add(_fromDoc(data));
      } catch (_) {
        // Ignore bad docs rather than crashing the whole list.
      }
    }

    return out;
  }
}
