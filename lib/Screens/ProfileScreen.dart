import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import 'SellerAddProductScreen.dart';
import 'BuyerAddressScreen.dart';
import 'AboutUsScreen.dart';
import 'MainNavScreen.dart';
import 'ProductDetailsScreen.dart';
import 'shared/product_controller.dart';
import 'shared/product_image.dart';
import 'shared/profile_mode_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final name = displayName.isEmpty ? 'Guest User' : displayName;
    final email = (user?.email ?? '').trim();
    final emailLabel = email.isEmpty ? '-' : email;
    final passwordLabel = user == null ? '-' : '********';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        title: const Text("Profile"),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([products, profileMode]),
        builder: (context, _) {
          final mode = profileMode.mode;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const CircleAvatar(
                  radius: 36,
                  child: Icon(Icons.person, size: 36),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              emailLabel,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.lock_outline, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              passwordLabel,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Password is always hidden for security.',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Buyer'),
                          selected: mode == ProfileMode.buyer,
                          onSelected: (_) => profileMode.setMode(ProfileMode.buyer),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Seller'),
                          selected: mode == ProfileMode.seller,
                          onSelected: (_) => profileMode.setMode(ProfileMode.seller),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (mode == ProfileMode.buyer) ...[
                  ListTile(
                    leading: const Icon(Icons.local_shipping_outlined),
                    title: const Text("Orders"),
                    onTap: () {
                      final nav = MainNavScope.maybeOf(context);
                      if (nav != null) {
                        nav.goToTab(1);
                        return;
                      }
                      Navigator.pushNamed(context, "/orders");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text("Addresses"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BuyerAddressScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("About Us"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                      );
                    },
                  ),
                ] else ...[
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Seller Products',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A8A1F),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SellerAddProductScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: products.mySellerProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'No products yet. Tap Add to create one.',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.separated(
                            itemCount: products.mySellerProducts.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final sp = products.mySellerProducts[i];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 64,
                                        height: 64,
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
                                            style: const TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_categoryLabel(sp.category)} • ${_audienceLabel(sp.audience)} • ${sp.product.shape}',
                                            style: const TextStyle(color: Colors.black54),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '₹${sp.product.price.toStringAsFixed(0)}',
                                            style: const TextStyle(fontWeight: FontWeight.w900),
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
                                      icon: const Icon(Icons.edit_outlined),
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
                                      icon: const Icon(Icons.visibility_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () => products.removeByIdAndPersist(sp.product.id),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],

                if (mode == ProfileMode.buyer) const Spacer(),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A8A1F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                  child: const Text(
                    "LOGOUT",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
