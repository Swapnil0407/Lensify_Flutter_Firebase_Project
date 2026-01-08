import 'package:flutter/foundation.dart';

@immutable
class FrameProduct {
  final String id;
  final String title;
  final String shape;
  final double price;
  final double? mrp;
  final String imageAsset;
  final String description;

  const FrameProduct({
    required this.id,
    required this.title,
    required this.shape,
    required this.price,
    this.mrp,
    required this.imageAsset,
    required this.description,
  });
}
