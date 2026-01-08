import '../Screens/PurchaseSheets/shared/frame_product.dart';
//import"package:lenscart/models/seller_product.dart';
//import 'package:lenscart/db/app_db.dart';
enum ProductCategory { eyeglasses, sunglasses }

enum Audience { men, women, kids }

class SellerProduct {
  final FrameProduct product;
  final ProductCategory category;
  final Audience audience;

  /// Optional image url (if provided, UI uses Image.network).
  final String? imageUrl;

  /// The user ID of the seller who created this product.
  final String? sellerId;

  const SellerProduct({
    required this.product,
    required this.category,
    required this.audience,
    this.imageUrl,
    this.sellerId,
  });

  /// Create a copy with updated sellerId
  SellerProduct copyWithSellerId(String? sellerId) {
    return SellerProduct(
      product: product,
      category: category,
      audience: audience,
      imageUrl: imageUrl,
      sellerId: sellerId,
    );
  }
}
