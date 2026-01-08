import 'package:flutter/material.dart';

import 'PurchaseSheets/shared/frame_product.dart';
import 'ProductDetailsScreen.dart';
import 'shared/product_controller.dart';
import 'shared/product_image.dart';

class ShapeProductsScreen extends StatelessWidget {
  final String categoryTitle;
  final String imageAsset;
  final String shape;

  const ShapeProductsScreen({
    super.key,
    required this.categoryTitle,
    required this.imageAsset,
    required this.shape,
  });

  ProductCategory _categoryFromTitle() {
    final t = categoryTitle.toLowerCase();
    return t.contains('sunglass') ? ProductCategory.sunglasses : ProductCategory.eyeglasses;
  }

  Audience _audienceFromTitle() {
    final t = categoryTitle.toLowerCase();
    if (t.contains('women')) return Audience.women;
    if (t.contains('kids')) return Audience.kids;
    return Audience.men;
  }

  void _openDetails(BuildContext context, FrameProduct product, String? imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(
          product: product,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductScope.of(context);
    final demoCategory = _categoryFromTitle();
    final demoAudience = _audienceFromTitle();

    return AnimatedBuilder(
      animation: productController,
      builder: (context, _) {
        final sellerMatches = productController.filter(
          category: demoCategory,
          audience: demoAudience,
          shape: shape,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFFFF7ED),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFF7ED),
            title: Text('$categoryTitle • $shape'),
          ),
          body: sellerMatches.isEmpty
              ? const Center(
                  child: Text(
                    'No products yet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
              itemCount: sellerMatches.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final sp = sellerMatches[index];
                final p = sp.product;
                final url = sp.imageUrl;
                return InkWell(
                  onTap: () => _openDetails(context, p, url),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ProductImage(
                            assetFallback: p.imageAsset,
                            imageUrl: url,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${p.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
