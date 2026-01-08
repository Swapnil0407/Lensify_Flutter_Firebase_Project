import 'package:sqflite/sqflite.dart';

import 'app_db.dart';

class BuyerProfile {
  final String? name;
  final String? phone;
  final String? address;

  const BuyerProfile({
    this.name,
    this.phone,
    this.address,
  });

  bool get isEmpty {
    return (name == null || name!.trim().isEmpty) &&
        (phone == null || phone!.trim().isEmpty) &&
        (address == null || address!.trim().isEmpty);
  }
}

class BuyerProfileRepo {
  const BuyerProfileRepo();

  static const _table = 'buyer_profile';
  static const _id = 1;

  Future<BuyerProfile?> getProfile() async {
    final db = await AppDb.instance.db;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [_id], limit: 1);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return BuyerProfile(
      name: r['name'] as String?,
      phone: r['phone'] as String?,
      address: r['address'] as String?,
    );
  }

  Future<void> upsertProfile(BuyerProfile profile) async {
    final db = await AppDb.instance.db;
    await db.insert(
      _table,
      {
        'id': _id,
        'name': profile.name,
        'phone': profile.phone,
        'address': profile.address,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clear() async {
    final db = await AppDb.instance.db;
    await db.delete(_table, where: 'id = ?', whereArgs: [_id]);
  }
}
