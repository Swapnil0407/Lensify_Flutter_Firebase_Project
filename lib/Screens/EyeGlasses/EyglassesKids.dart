import 'package:flutter/material.dart';
import 'package:lensify/Screens/shared/product_controller.dart';
import '../ShapeProductsScreen.dart';

class EyeglassKids extends StatefulWidget {
  const EyeglassKids({super.key});
  @override
  State<EyeglassKids> createState() => _EyeglassKidsState();
}

class _EyeglassKidsState extends State<EyeglassKids> {
  void _openShape(String shape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapeProductsScreen(
          categoryTitle: "Kids Eyeglasses",
          imageAsset: "assets/images/eyeKids.jpg",
          shape: shape,
        ),
      ),
    );
  }

  Widget _shapeCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color.fromARGB(140, 236, 236, 237),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductScope.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: products,
          builder: (context, _) {
            if (!products.loadedFromDb) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Text(
                    "Kid's Eyeglasses",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _shapeCard(
                        title: "Square",
                        imagePath:
                            "assets/images/Frame/SunKidsSquare.jpg",
                        onTap: () => _openShape("Square"),
                      ),
                      _shapeCard(
                        title: "Rectangle",
                        imagePath:
                            "assets/images/Frame/SunKidsRectangle.jpg",
                        onTap: () => _openShape("Rectangle"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _shapeCard(
                        title: "Aviator",
                        imagePath:
                            "assets/images/Frame/SunKidsAviator.jpg",
                        onTap: () => _openShape("Aviator"),
                      ),
                      _shapeCard(
                        title: "Geometric",
                        imagePath:
                            "assets/images/Frame/SunKidsGeometric.jpg",
                        onTap: () => _openShape("Geometric"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
