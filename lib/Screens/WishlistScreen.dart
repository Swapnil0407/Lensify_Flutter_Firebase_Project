import 'package:flutter/material.dart';
import 'shared/screen_entrance.dart';
import 'shared/wishlist_controller.dart';
import 'shared/product_image.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void _removeFromWishlist(BuildContext context, String id) {
    final wishlistController = WishlistScope.of(context);
    wishlistController.removeFromWishlist(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from wishlist'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController = WishlistScope.of(context);

    return ScreenEntrance(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: AnimatedBuilder(
            animation: wishlistController,
            builder: (context, _) {
              return Text(
                'My Wishlist${wishlistController.count > 0 ? ' (${wishlistController.count})' : ''}',
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),
        ),
        body: AnimatedBuilder(
          animation: wishlistController,
          builder: (context, _) {
            final wishlistItems = wishlistController.items;

            if (wishlistItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite items here',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A8A1F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return _buildWishlistCard(context, item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, WishlistItem item) {
    // Calculate demo discount
    final oldPrice = (item.price * 1.4).toInt();
    final discount = (((oldPrice - item.price) / oldPrice) * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey.shade100,
              child: ProductImage(
                assetFallback: item.imageAsset,
                imageUrl: item.imageUrl,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                      onPressed: () => _removeFromWishlist(context, item.productId),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Frame Width: ${item.frameWidth} • ${item.shape}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹$oldPrice',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$discount% OFF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
