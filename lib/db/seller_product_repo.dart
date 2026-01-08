import 'package:sqflite/sqflite.dart';

import '../Screens/PurchaseSheets/shared/frame_product.dart';
import '../models/seller_product.dart';
import 'package:lenscart/db/app_db.dart';

class SellerProductRepo {
  const SellerProductRepo();

  static const _table = 'seller_products';

  Map<String, Object?> _toRow(SellerProduct p) {
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
    };
  }

  SellerProduct _fromRow(Map<String, Object?> r) {
    final product = FrameProduct(
      id: r['id'] as String,
      title: r['title'] as String,
      shape: r['shape'] as String,
      price: (r['price'] as num).toDouble(),
      mrp: (r['mrp'] as num?)?.toDouble(),
      imageAsset: r['imageAsset'] as String,
      description: r['description'] as String,
    );

    return SellerProduct(
      product: product,
      category: ProductCategory.values.byName(r['category'] as String),
      audience: Audience.values.byName(r['audience'] as String),
      imageUrl: r['imageUrl'] as String?,
      sellerId: r['sellerId'] as String?,
    );
  }

  Future<void> upsert(SellerProduct p) async {
    final db = await AppDb.instance.db;
    await db.insert(
      _table,
      _toRow(p),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteById(String id) async {
    final db = await AppDb.instance.db;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SellerProduct>> listAll() async {
    final db = await AppDb.instance.db;
    final rows = await db.query(_table, orderBy: 'rowid DESC');
    return rows.map(_fromRow).toList(growable: false);
  }

  /// List products for a specific seller only
  Future<List<SellerProduct>> listBySellerId(String sellerId) async {
    final db = await AppDb.instance.db;
    final rows = await db.query(
      _table,
      where: 'sellerId = ?',
      whereArgs: [sellerId],
      orderBy: 'rowid DESC',
    );
    return rows.map(_fromRow).toList(growable: false);
  }
}
