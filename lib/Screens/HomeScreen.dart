import "dart:async";
import "package:flutter/material.dart";

import 'ShapeProductsScreen.dart';
import 'shared/shape_picker_sheet.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool _isLoading = true;
  bool _didInitialLoad = false;

  late final PageController _pageController;
  Timer? _timer;

  // Replace setState-based index with a notifier (updates only the dots)
  final ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);

  final List<String> _bannerImages = [
    "assets/images/splash1.jpg",
    "assets/images/splash2.jpg",
  ];

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
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ShapePickerSheet(
          title: sheetTitle,
          imageAsset: imageAsset,
          framePrefix: framePrefix,
          imageUrlForShape: (_) => '',
          onShapeSelected: (shape) {
            Navigator.of(context).pop();
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

  Future<void> _loadHome() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    // Preload banner images (prevents flicker) + show loader briefly
    await Future.wait(
      _bannerImages.map((path) => precacheImage(AssetImage(path), context)),
    );

    // Optional: small delay to make loader visible (remove if you don't want it)
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;

      final next = (_pageIndex.value + 1) % _bannerImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Run initial load once (context-safe)
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFF7ED),
            leading: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => _go("/profile"),
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.favorite_border),
              //   onPressed: () => _go("/favorites"),
              // ),
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => _go("/cart"),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFFFFF7ED),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Search for products, brands and more",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: const Icon(Icons.mic),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 160,
                            child: RepaintBoundary(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _bannerImages.length,
                                onPageChanged: (index) {
                                  _pageIndex.value = index; // no setState
                                },
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    _bannerImages[index],
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Eyeglasses
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Eyeglasses",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Men Eyeglasses",
                                categoryTitle: "Men Eyeglasses",
                                imageAsset: "assets/images/eyeMen.jpg",
                                framePrefix: "EyeMen",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/eyeMen.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Men",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Women Eyeglasses",
                                categoryTitle: "Women Eyeglasses",
                                imageAsset: "assets/images/eyeWomen.jpg",
                                framePrefix: "EyeWomen",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/eyeWomen.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Women",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Kids Eyeglasses",
                                categoryTitle: "Kids Eyeglasses",
                                imageAsset: "assets/images/eyeKids.jpg",
                                framePrefix: "SunKids",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/eyeKids.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Kids",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sunglasses
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Sunglasses",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Men Sunglasses",
                                categoryTitle: "Men Sunglasses",
                                imageAsset: "assets/images/MenSun.jpg",
                                framePrefix: "SunMen",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/MenSun.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Men",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Women Sunglasses",
                                categoryTitle: "Women Sunglasses",
                                imageAsset: "assets/images/WomenSun.jpg",
                                framePrefix: "SunWomen",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/WomenSun.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Women",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _openCategorySheet(
                                sheetTitle: "Kids Sunglasses",
                                categoryTitle: "Kids Sunglasses",
                                imageAsset: "assets/images/KidsSun.jpg",
                                framePrefix: "SunKids",
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/KidsSun.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Kids",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Contact Lenses & Accessories
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Lenses & Accessories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/Clearlens.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Clear",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/Colorlens.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Color",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/solution.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Solution",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Lenskart Specials
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Lenskart Specials",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/Replacelens.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "LensReplace",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/Zeropower.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Zeropower",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/Readinglens.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.black54,
                                  child: const Text(
                                    "Reading",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) ...[
          const ModalBarrier(dismissible: false, color: Colors.black26),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}