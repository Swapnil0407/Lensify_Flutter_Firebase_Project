import 'package:flutter/material.dart';

import 'PurchaseSheets/shared/frame_product.dart';
import 'BuyerPurchaseScreen.dart';
import 'SellerAddProductScreen.dart';
import 'shared/cart_controller.dart';
import 'shared/product_controller.dart';
import 'shared/product_image.dart';
import 'shared/screen_entrance.dart';

class ProductDetailsScreen extends StatelessWidget {
  final FrameProduct product;
  final String? imageUrl;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.imageUrl,
  });

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductScope.of(context);
    final sellerProduct = products.all
        .where((p) => p.product.id == product.id)
        .cast<SellerProduct?>()
        .firstOrNull;

    return ScreenEntrance(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7ED),
          title: const Text('Product Details'),
          actions: [
          if (sellerProduct != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellerAddProductScreen.edit(existing: sellerProduct),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, "/cart"),
          ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: ProductImage(
                  assetFallback: product.imageAsset,
                  imageUrl: imageUrl,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Shape: ${product.shape}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 10),
                if (product.mrp != null && product.mrp! > product.price)
                  Text(
                    '₹${product.mrp!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(fontSize: 14, height: 1.35),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      CartScope.of(context).add(product, imageUrl: imageUrl);
                      _toast(context, 'Added to cart: ${product.title}');
                    },
                    child: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A8A1F),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BuyerPurchaseScreen(
                            product: product,
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
