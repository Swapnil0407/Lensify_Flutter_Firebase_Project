import "dart:async";
import "package:flutter/material.dart";

import 'ShapeProductsScreen.dart';
import 'shared/shape_picker_sheet.dart';
import 'shared/screen_entrance.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen>
    with SingleTickerProviderStateMixin {

  bool _isLoading = true;
  bool _didInitialLoad = false;

  late final PageController _pageController;
  Timer? _timer;

  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  final TextEditingController _searchController = TextEditingController();

  final List<String> _bannerImages = [
    "assets/images/splash1.jpg",
    "assets/images/splash2.jpg",
    "assets/images/Splash.jpg",
    "assets/images/eyeMen.jpg",
    "assets/images/eyeWomen.jpg",
    "assets/images/MenSun.jpg",
    "assets/images/WomenSun.jpg",
  ];

  // Feature Cards Data
  final List<Map<String, String>> _featureCards = [
    {
      'title': 'Crystal Clear',
      'subtitle': 'Transparent Frames',
      'image': 'assets/images/eyeWomen.jpg',
    },
    {
      'title': 'Exclusive Collection',
      'subtitle': 'John Jacobs × Stranger Things',
      'image': 'assets/images/eyeMen.jpg',
    },
    {
      'title': 'Feather-light',
      'subtitle': 'Lenskart Air',
      'image': 'assets/images/eyeKids.jpg',
    },
    {
      'title': '2 in 1: Eye + Sun',
      'subtitle': 'Hustlr Switch',
      'image': 'assets/images/MenSun.jpg',
    },
    {
      'title': 'Magnetic Charms',
      'subtitle': 'Bitz',
      'image': 'assets/images/WomenSun.jpg',
    },
    {
      'title': 'Festive Collection',
      'subtitle': 'Indian Accent',
      'image': 'assets/images/splash1.jpg',
    },
    {
      'title': 'Premium Eyewear',
      'subtitle': 'John Jacobs',
      'image': 'assets/images/splash2.jpg',
    },
    {
      'title': 'Smart Glasses',
      'subtitle': 'Phonic',
      'image': 'assets/images/Splash.jpg',
    },
  ];

  // 🎬 Netflix / Hotstar background animation
  late AnimationController _bgController;
  late Animation<double> _bgAnim;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_pageIndex.value + 1) % _bannerImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _bgAnim = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadHome() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    await Future.wait(
      _bannerImages.map((p) => precacheImage(AssetImage(p), context)),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitialLoad) {
      _didInitialLoad = true;
      _loadHome();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _pageIndex.dispose();
    _searchController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    final lowerQuery = query.toLowerCase().trim();
    
    if (lowerQuery.isEmpty) return;

    // Eyeglasses Men
    if ((lowerQuery.contains('eyeglass') || lowerQuery.contains('glass')) && lowerQuery.contains('men')) {
      _openCategorySheet(
        sheetTitle: "Men Eyeglasses",
        categoryTitle: "Men Eyeglasses",
        imageAsset: "assets/images/eyeMen.jpg",
        framePrefix: "EyeMen",
      );
    }
    // Eyeglasses Women
    else if ((lowerQuery.contains('eyeglass') || lowerQuery.contains('glass')) && lowerQuery.contains('women')) {
      _openCategorySheet(
        sheetTitle: "Women Eyeglasses",
        categoryTitle: "Women Eyeglasses",
        imageAsset: "assets/images/eyeWomen.jpg",
        framePrefix: "EyeWomen",
      );
    }
    // Eyeglasses Kids
    else if ((lowerQuery.contains('eyeglass') || lowerQuery.contains('glass')) && lowerQuery.contains('kid')) {
      _openCategorySheet(
        sheetTitle: "Kids Eyeglasses",
        categoryTitle: "Kids Eyeglasses",
        imageAsset: "assets/images/eyeKids.jpg",
        framePrefix: "SunKids",
      );
    }
    // Sunglasses Men
    else if (lowerQuery.contains('sun') && lowerQuery.contains('men')) {
      _openCategorySheet(
        sheetTitle: "Men Sunglasses",
        categoryTitle: "Men Sunglasses",
        imageAsset: "assets/images/MenSun.jpg",
        framePrefix: "SunMen",
      );
    }
    // Sunglasses Women
    else if (lowerQuery.contains('sun') && lowerQuery.contains('women')) {
      _openCategorySheet(
        sheetTitle: "Women Sunglasses",
        categoryTitle: "Women Sunglasses",
        imageAsset: "assets/images/WomenSun.jpg",
        framePrefix: "SunWomen",
      );
    }
    // Sunglasses Kids
    else if (lowerQuery.contains('sun') && lowerQuery.contains('kid')) {
      _openCategorySheet(
        sheetTitle: "Kids Sunglasses",
        categoryTitle: "Kids Sunglasses",
        imageAsset: "assets/images/KidsSun.jpg",
        framePrefix: "SunKids",
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No results found for "$query"'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _go(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _openCategorySheet({
    required String sheetTitle,
    required String imageAsset,
    required String categoryTitle,
    required String framePrefix,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ShapePickerSheet(
          title: sheetTitle,
          imageAsset: imageAsset,
          framePrefix: framePrefix,
          imageUrlForShape: (_) => '',
          onShapeSelected: (shape) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShapeProductsScreen(
                  categoryTitle: categoryTitle,
                  imageAsset: imageAsset,
                  shape: shape,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenEntrance(
      child: Stack(
        children: [

          /// 🎬 OTT ANIMATED BACKGROUND
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(const Color(0xFFFFF9F0),
                          const Color(0xFFFFE8D6), _bgAnim.value)!,
                      Color.lerp(const Color(0xFFFFF5E8),
                          const Color(0xFFFFEBD8), _bgAnim.value)!,
                      Color.lerp(const Color(0xFFFFF0E0),
                          const Color(0xFFFFE4CC), _bgAnim.value)!,
                    ],
                  ),
                ),
              );
            },
          ),

          /// 🏠 HOME UI
          Scaffold(
            backgroundColor: Colors.transparent,

            // ⭐ UNIQUE APPBAR
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFF7ED),
              elevation: 0,
              centerTitle: true,

              leading: IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => _go("/profile"),
              ),

              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      size: 18,
                      color: Color(0xFF0A8A1F),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Lensify",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => _go("/cart"),
                ),
              ],
            ),

            body: Column(
              children: [
                // SEARCH BAR - FIXED AT TOP
                Container(
                  color: const Color(0xFFFFF7ED),
                  padding: const EdgeInsets.all(10),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, -20 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: _handleSearch,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Search for products, brands and more",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () => _handleSearch(_searchController.text),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: const Color(0xFFFFF7ED),
                      child: Column(
                        children: [

                    // BANNER
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: _bannerImages.length,
                                    onPageChanged: (i) => _pageIndex.value = i,
                                    itemBuilder: (_, i) => Image.asset(
                                      _bannerImages[i],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🌟 FEATURE CARDS SECTION
                    _sectionTitle("✨ Featured Collections ✨"),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _featureCards.length,
                        itemBuilder: (context, index) {
                          final card = _featureCards[index];
                          return _buildFeatureCard(
                            title: card['title']!,
                            subtitle: card['subtitle']!,
                            imageAsset: card['image']!,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${card['title']} - Coming Soon!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    _sectionTitle("👓 Eyeglasses 👓"),
                    const SizedBox(height: 5),
                    _row([
                      _card("Men", "assets/images/eyeMen.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Men Eyeglasses",
                              categoryTitle: "Men Eyeglasses",
                              imageAsset: "assets/images/eyeMen.jpg",
                              framePrefix: "EyeMen")),
                      _card("Women", "assets/images/eyeWomen.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Women Eyeglasses",
                              categoryTitle: "Women Eyeglasses",
                              imageAsset: "assets/images/eyeWomen.jpg",
                              framePrefix: "EyeWomen")),
                      _card("Kids", "assets/images/eyeKids.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Kids Eyeglasses",
                              categoryTitle: "Kids Eyeglasses",
                              imageAsset: "assets/images/eyeKids.jpg",
                              framePrefix: "SunKids")),
                    ]),

                    const SizedBox(height: 25),

                    _sectionTitle("🕶️ Sunglasses 🕶️"),
                    const SizedBox(height: 5),
                    _row([
                      _card("Men", "assets/images/MenSun.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Men Sunglasses",
                              categoryTitle: "Men Sunglasses",
                              imageAsset: "assets/images/MenSun.jpg",
                              framePrefix: "SunMen")),
                      _card("Women", "assets/images/WomenSun.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Women Sunglasses",
                              categoryTitle: "Women Sunglasses",
                              imageAsset: "assets/images/WomenSun.jpg",
                              framePrefix: "SunWomen")),
                      _card("Kids", "assets/images/KidsSun.jpg", () =>
                          _openCategorySheet(
                              sheetTitle: "Kids Sunglasses",
                              categoryTitle: "Kids Sunglasses",
                              imageAsset: "assets/images/KidsSun.jpg",
                              framePrefix: "SunKids")),
                    ]),

                    const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoading) ...[
            const ModalBarrier(dismissible: false, color: Colors.black26),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(List<Widget> children) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children.map((child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: child,
        )).toList(),
      ),
    );
  }

  Widget _card(String title, String image, VoidCallback onTap) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140,
                width: 110,
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 🌟 FEATURE CARD WIDGET
  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Opacity(
            opacity: value,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Bottom Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Text Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
