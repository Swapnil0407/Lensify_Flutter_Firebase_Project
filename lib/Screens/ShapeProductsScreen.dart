import 'package:flutter/material.dart';

import 'FiltersScreen.dart';
import 'WishlistScreen.dart';
import 'PurchaseSheets/shared/frame_product.dart';
import 'ProductDetailsScreen.dart';
import 'shared/product_controller.dart';
import 'shared/product_image.dart';
import 'shared/screen_entrance.dart';
import 'shared/sort_bottom_sheet.dart';
import 'shared/wishlist_controller.dart';

class ShapeProductsScreen extends StatefulWidget {
  final String categoryTitle;
  final String imageAsset;
  final String shape;

  const ShapeProductsScreen({
    super.key,
    required this.categoryTitle,
    required this.imageAsset,
    required this.shape,
  });

  @override
  State<ShapeProductsScreen> createState() => _ShapeProductsScreenState();
}

class _ShapeProductsScreenState extends State<ShapeProductsScreen> {
  String _selectedTab = 'All';
  SortOption _currentSort = SortOption.recommended;
  int _appliedFiltersCount = 0;
  bool _isTileView = true;

  final List<String> _tabs = ['All', 'Sale', 'Classic', 'Premium'];

  ProductCategory _categoryFromTitle() {
    final t = widget.categoryTitle.toLowerCase();
    return t.contains('sunglass') ? ProductCategory.sunglasses : ProductCategory.eyeglasses;
  }

  Audience _audienceFromTitle() {
    final t = widget.categoryTitle.toLowerCase();
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

  void _toggleWishlist(BuildContext context, SellerProduct sp) {
    final wishlistController = WishlistScope.of(context);
    final p = sp.product;
    
    final wishlistItem = WishlistItem(
      productId: p.id,
      title: p.title,
      imageAsset: p.imageAsset,
      imageUrl: sp.imageUrl,
      price: p.price,
      shape: widget.shape,
      frameWidth: 'Medium',
    );

    wishlistController.toggleWishlist(wishlistItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wishlistController.isWishlisted(p.id)
              ? 'Added to wishlist'
              : 'Removed from wishlist',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductScope.of(context);
    final wishlistController = WishlistScope.of(context);
    final demoCategory = _categoryFromTitle();
    final demoAudience = _audienceFromTitle();

    return AnimatedBuilder(
      animation: Listenable.merge([productController, wishlistController]),
      builder: (context, _) {
        final sellerMatches = productController.filter(
          category: demoCategory,
          audience: demoAudience,
          shape: widget.shape,
        );

        return ScreenEntrance(
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${widget.shape} ${widget.categoryTitle}',
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black87),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black87),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WishlistScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  children: [
                    // Horizontal Tabs
                    Container(
                      height: 48,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _tabs.length,
                        itemBuilder: (context, index) {
                          final tab = _tabs[index];
                          final isSelected = _selectedTab == tab;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTab = tab;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF0A8A1F)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF1A1A2E)
                                      : Colors.grey.shade600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ),
            body: sellerMatches.isEmpty
                ? const Center(
                    child: Text(
                      'No products yet',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: sellerMatches.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final sp = sellerMatches[index];
                      return _buildProductCard(sp);
                    },
                  ),

            // Bottom Sticky Action Bar
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Sort Button
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.sort,
                        label: 'Sort',
                        subtitle: _getSortLabel(_currentSort),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => SortBottomSheet(
                              currentSort: _currentSort,
                              onSortSelected: (sort) {
                                setState(() => _currentSort = sort);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Filter Button
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.tune,
                        label: 'Filter',
                        subtitle: _appliedFiltersCount > 0
                            ? '$_appliedFiltersCount Applied'
                            : '0 Applied',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FiltersScreen(),
                            ),
                          );
                          if (result != null && mounted) {
                            setState(() {
                              _appliedFiltersCount = (result as Set).length;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // View Toggle Button
                    Expanded(
                      child: _buildActionButton(
                        icon: _isTileView ? Icons.view_module : Icons.view_list,
                        label: 'View',
                        subtitle: _isTileView ? 'Tile View' : 'List View',
                        onTap: () {
                          setState(() {
                            _isTileView = !_isTileView;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.recommended:
        return 'Recommended';
      case SortOption.bestsellers:
        return 'Bestsellers';
      case SortOption.newArrivals:
        return 'New';
      case SortOption.priceLowToHigh:
        return 'Price ↑';
      case SortOption.priceHighToLow:
        return 'Price ↓';
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF1A1A2E)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(SellerProduct sp) {
    final p = sp.product;
    final url = sp.imageUrl;

    return Builder(
      builder: (context) {
        final wishlistController = WishlistScope.of(context);
        final isWishlisted = wishlistController.isWishlisted(p.id);

        return InkWell(
          onTap: () => _openDetails(context, p, url),
          borderRadius: BorderRadius.circular(18),
          child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Rating & Wishlist
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? Colors.red : Colors.grey.shade600,
                    size: 24,
                  ),
                  onPressed: () => _toggleWishlist(context, sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Product Image
            Center(
              child: SizedBox(
                height: 160,
                child: ProductImage(
                  assetFallback: p.imageAsset,
                  imageUrl: url,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // POWERED Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'POWERED',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade700,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Product Title
            Text(
              p.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Color Selection Dots
            Row(
              children: [
                _buildColorDot(Colors.black),
                const SizedBox(width: 6),
                _buildColorDot(Colors.brown),
                const SizedBox(width: 6),
                _buildColorDot(Colors.blue.shade800),
                const SizedBox(width: 6),
                _buildColorDot(Colors.grey.shade400),
              ],
            ),

            const SizedBox(height: 10),

            // Frame Width Info
            Row(
              children: [
                Icon(Icons.square_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  'Frame Width: Medium',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Measure Face Width Button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.straighten, size: 16, color: Colors.grey.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'Measure Face Width',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Price Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const Text(
                      'with lenses',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  '₹${(p.price * 1.4).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '29% OFF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Coupon Text
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade200,
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade700,
                        ),
                        children: const [
                          TextSpan(text: 'Use code '),
                          TextSpan(
                            text: 'FREEDOM',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
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
    );
  }

  Widget _buildColorDot(Color color) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
    );
  }
}
