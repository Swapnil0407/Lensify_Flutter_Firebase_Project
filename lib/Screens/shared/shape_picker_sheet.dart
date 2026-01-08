import 'package:flutter/material.dart';

class ShapePickerSheet extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String framePrefix; // e.g., "EyeMen", "SunWomen", "SunKids"
  final String Function(String shape) imageUrlForShape;
  final void Function(String shape) onShapeSelected;

  const ShapePickerSheet({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.framePrefix,
    required this.imageUrlForShape,
    required this.onShapeSelected,
  });

  static const List<String> _shapes = [
    'Square',
    'Rectangle',
    'Aviator',
    'Geometric',
  ];

  String _getFrameImage(String shape) {
    return 'assets/images/Frame/$framePrefix$shape.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF7ED),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: _shapes.map((shape) {
                  final url = imageUrlForShape(shape);
                  final frameImage = _getFrameImage(shape);
                  return InkWell(
                    onTap: () => onShapeSelected(shape),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: url.trim().isEmpty
                                  ? Image.asset(
                                      frameImage,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                      errorBuilder: (c, e, s) => Image.asset(
                                        frameImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: const Color.fromARGB(140, 236, 236, 237),
                            child: Text(
                              shape,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
