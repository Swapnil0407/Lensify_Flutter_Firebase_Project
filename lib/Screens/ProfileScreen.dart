import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import 'SellerAddProductScreen.dart';
import 'BuyerAddressScreen.dart';
import 'AboutUsScreen.dart';
import 'MainNavScreen.dart';
import 'ProductDetailsScreen.dart';
import 'WishlistScreen.dart';
import 'shared/product_controller.dart';
import 'shared/product_image.dart';
import 'shared/profile_mode_controller.dart';
import 'shared/screen_entrance.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  // Define admin email addresses here
  static const List<String> _adminEmails = [
    'admin@lensify.com',
    'seller@lensify.com',
    // Add your admin email addresses here
  ];

  bool _isAdmin() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    final email = user.email?.toLowerCase().trim() ?? '';
    return _adminEmails.contains(email);
  }

  String _categoryLabel(ProductCategory c) {
    switch (c) {
      case ProductCategory.eyeglasses:
        return 'Eyeglasses';
      case ProductCategory.sunglasses:
        return 'Sunglasses';
    }
  }

  String _audienceLabel(Audience a) {
    switch (a) {
      case Audience.men:
        return 'Men';
      case Audience.women:
        return 'Women';
      case Audience.kids:
        return 'Kids';
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductScope.of(context);
    final profileMode = ProfileModeScope.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final displayName = (user?.displayName ?? '').trim();
    final name = displayName.isEmpty ? 'User' : displayName;
    final isLoggedIn = user != null;

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
          title: const Text(
            "My Profile",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
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
              onPressed: () {
                final nav = MainNavScope.maybeOf(context);
                if (nav != null) nav.goToTab(2);
              },
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: Listenable.merge([products, profileMode]),
          builder: (context, _) {
            final mode = profileMode.mode;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isLoggedIn ? "Hi $name!" : "Hi User!",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLoggedIn
                              ? "Manage your account and explore exclusive deals"
                              : "Login or Signup to track your orders and get access to exclusive deals",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (!isLoggedIn) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A8A1F),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "/login",
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Login or Signup",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Quick Actions Grid
                  if (isLoggedIn) ...[
                    _buildSectionCard(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                          children: [
                            _buildQuickAction(
                              context,
                              icon: Icons.shopping_bag_outlined,
                              label: "Orders",
                              onTap: () {
                                final nav = MainNavScope.maybeOf(context);
                                if (nav != null) {
                                  nav.goToTab(1);
                                } else {
                                  Navigator.pushNamed(context, "/orders");
                                }
                              },
                            ),
                            _buildQuickAction(
                              context,
                              icon: Icons.favorite_border,
                              label: "Wishlist",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WishlistScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildQuickAction(
                              context,
                              icon: Icons.notifications_outlined,
                              label: "Notification",
                              onTap: () {},
                            ),
                            _buildQuickAction(
                              context,
                              icon: Icons.account_balance_wallet_outlined,
                              label: "Wallet",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),

                    // My Eyes Section
                    _buildSectionCard(
                      title: "My Eyes",
                      children: [
                        _buildMenuItem(
                          icon: Icons.remove_red_eye_outlined,
                          title: "My saved powers",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.square_outlined,
                          title: "My frame size",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.view_in_ar_outlined,
                          title: "AR try-on (1000+ frames)",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.threed_rotation_outlined,
                          title: "My saved 3D models",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Gift Cards Section
                    _buildSectionCard(
                      title: "Gift Cards",
                      children: [
                        _buildMenuItem(
                          icon: Icons.card_giftcard_outlined,
                          title: "Gift Card Wallet Balance",
                          subtitle: "₹0.00",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.shop_outlined,
                          title: "Purchase Gift Card",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.redeem_outlined,
                          title: "Claim Gift Card",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // My Settings Section
                    _buildSectionCard(
                      title: "My Settings",
                      children: [
                        _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: "My addresses",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BuyerAddressScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: "My notifications",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: "Manage notifications",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Get Help Section
                    _buildSectionCard(
                      title: "Get Help",
                      children: [
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: "Frequently asked questions",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.chat_outlined,
                          title: "Contact us",
                          subtitle: "WhatsApp Support",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Others Section
                    _buildSectionCard(
                      title: "Others",
                      children: [
                        _buildMenuItem(
                          icon: Icons.info_outline,
                          title: "About App",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutUsScreen(),
                              ),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.share_outlined,
                          title: "Share screen with agent",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.star_border,
                          title: "Rate us",
                          onTap: () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.more_horiz,
                          title: "More options",
                          onTap: () {},
                        ),
                      ],
                    ),

                    // Admin Section (Only for admin users)
                    if (_isAdmin()) ...[
                      _buildSectionCard(
                        title: "Admin Panel",
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.admin_panel_settings, color: Colors.orange.shade700),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Admin Mode',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                ChoiceChip(
                                  label: Text(mode == ProfileMode.buyer ? 'Buyer' : 'Seller'),
                                  selected: true,
                                  onSelected: (_) {
                                    profileMode.setMode(
                                      mode == ProfileMode.buyer
                                          ? ProfileMode.seller
                                          : ProfileMode.buyer,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (mode == ProfileMode.seller) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Seller Products',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A8A1F),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SellerAddProductScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                                  label: const Text(
                                    'Add Product',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...products.mySellerProducts.map((sp) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: ProductImage(
                                          assetFallback: sp.product.imageAsset,
                                          imageUrl: sp.imageUrl,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sp.product.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_categoryLabel(sp.category)} • ${_audienceLabel(sp.audience)}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${sp.product.price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SellerAddProductScreen.edit(
                                              existing: sp,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit_outlined, size: 20),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailsScreen(
                                              product: sp.product,
                                              imageUrl: sp.imageUrl,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.visibility_outlined, size: 20),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          products.removeByIdAndPersist(sp.product.id),
                                      icon: Icon(Icons.delete_outline,
                                          size: 20, color: Colors.red.shade700),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (products.mySellerProducts.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'No products yet. Tap "Add Product" to create one.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ],

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.red.shade400, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            "/login",
                            (route) => false,
                          );
                        },
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard({String? title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade700, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
