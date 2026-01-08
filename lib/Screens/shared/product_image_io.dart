import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String assetFallback;
  final String? imageUrl;

  const ProductImage({
    super.key,
    required this.assetFallback,
    this.imageUrl,
  });

  bool _isHttpUrl(String s) {
    final lower = s.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final raw = imageUrl?.trim();
    if (raw != null && raw.isNotEmpty) {
      if (_isHttpUrl(raw)) {
        return Image.network(
          raw,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Image.asset(
            assetFallback,
            fit: BoxFit.cover,
            errorBuilder: (c2, e2, s2) => const Icon(
              Icons.image_not_supported_outlined,
            ),
          ),
        );
      }

      final uri = Uri.tryParse(raw);
      final filePath = (uri != null && uri.scheme == 'file') ? uri.toFilePath() : raw;

      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Image.asset(
          assetFallback,
          fit: BoxFit.cover,
          errorBuilder: (c2, e2, s2) => const Icon(
            Icons.image_not_supported_outlined,
          ),
        ),
      );
    }

    return Image.asset(
      assetFallback,
      fit: BoxFit.cover,
      errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported_outlined),
    );
  }
}
