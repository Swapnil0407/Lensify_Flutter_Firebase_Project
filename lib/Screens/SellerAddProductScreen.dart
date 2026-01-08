import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'PurchaseSheets/shared/frame_product.dart';
import 'shared/product_controller.dart';
import 'shared/profile_mode_controller.dart';

import '../app_keys.dart';

class SellerAddProductScreen extends StatefulWidget {
  final SellerProduct? existing;

  const SellerAddProductScreen({super.key, this.existing});

  const SellerAddProductScreen.edit({
    super.key,
    required SellerProduct existing,
  }) : existing = existing;

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final String _id;

  ProductCategory _category = ProductCategory.eyeglasses;
  Audience _audience = Audience.men;
  String _shape = 'Square';

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  String? _imagePath;

  Uint8List? _pickedImageBytes;
  bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    _id = widget.existing?.product.id ?? 'seller_${DateTime.now().millisecondsSinceEpoch}';
    final ex = widget.existing;
    if (ex == null) return;

    _category = ex.category;
    _audience = ex.audience;
    _shape = ex.product.shape;

    _title.text = ex.product.title;
    _description.text = ex.product.description;
    _price.text = ex.product.price.toStringAsFixed(0);
    _mrp.text = ex.product.mrp?.toStringAsFixed(0) ?? '';
    _imagePath = ex.imageUrl;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _mrp.dispose();
    super.dispose();
  }

  void _toast(String message) {
    rootScaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<Uint8List?> _compressToJpegUnderLimit(
    Uint8List input, {
    required int maxBytes,
  }) async {
    final decoded = img.decodeImage(input);
    if (decoded == null) return null;

    // Resize to keep memory and bytes low.
    img.Image current = decoded;
    const maxDimStart = 1024;
    if (current.width > maxDimStart || current.height > maxDimStart) {
      current = img.copyResize(
        current,
        width: current.width >= current.height ? maxDimStart : null,
        height: current.height > current.width ? maxDimStart : null,
      );
    }

    // Try different JPEG quality levels.
    Uint8List best = Uint8List.fromList(img.encodeJpg(current, quality: 90));
    if (best.lengthInBytes <= maxBytes) return best;

    for (final q in [80, 70, 60, 50, 45, 40, 35, 30]) {
      final bytes = Uint8List.fromList(img.encodeJpg(current, quality: q));
      best = bytes;
      if (bytes.lengthInBytes <= maxBytes) return bytes;
    }

    // If still too large, progressively downscale and retry.
    for (final dim in [900, 800, 700, 600, 500, 400]) {
      if (current.width <= dim && current.height <= dim) continue;
      final resized = img.copyResize(
        current,
        width: current.width >= current.height ? dim : null,
        height: current.height > current.width ? dim : null,
      );

      for (final q in [70, 60, 50, 45, 40, 35, 30]) {
        final bytes = Uint8List.fromList(img.encodeJpg(resized, quality: q));
        best = bytes;
        if (bytes.lengthInBytes <= maxBytes) return bytes;
      }
    }

    return null;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (res == null || res.files.isEmpty) return;

      final f = res.files.first;
      final bytes = f.bytes;
      if (bytes == null || bytes.isEmpty) {
        _toast('Could not read image bytes');
        return;
      }

      // Compress under 1MB.
      const maxBytes = 1024 * 1024;
      final compressed = await _compressToJpegUnderLimit(bytes, maxBytes: maxBytes);
      if (compressed == null) {
        _toast('Image too large. Please choose a smaller image.');
        return;
      }

      setState(() {
        _pickedImageBytes = compressed;
        _uploadingImage = true;
      });

      // Single image per product: always overwrite the same object.
      final path = 'seller_products/$_id/main.jpg';

      final ref = FirebaseStorage.instance.ref().child(path);
      final meta = SettableMetadata(contentType: 'image/jpeg');
      final task = await ref.putData(compressed, meta);
      final url = await task.ref.getDownloadURL();

      if (!mounted) return;
      setState(() {
        _imagePath = url;
      });
      _toast('Image uploaded (${(compressed.lengthInBytes / 1024).toStringAsFixed(0)} KB)');
    } catch (e) {
      _toast('Image upload failed');
    } finally {
      if (mounted) {
        setState(() => _uploadingImage = false);
      }
    }
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_uploadingImage) {
      _toast('Please wait for image upload to finish');
      return;
    }

    final price = double.parse(_price.text.trim());
    final mrpText = _mrp.text.trim();
    final mrp = mrpText.isEmpty ? null : double.tryParse(mrpText);

    // Fallback to existing assets based on category/audience (UI-only).
    final asset = switch ((_category, _audience)) {
      (ProductCategory.eyeglasses, Audience.men) => 'assets/images/eyeMen.jpg',
      (ProductCategory.eyeglasses, Audience.women) => 'assets/images/eyeWomen.jpg',
      (ProductCategory.eyeglasses, Audience.kids) => 'assets/images/eyeKids.jpg',
      (ProductCategory.sunglasses, Audience.men) => 'assets/images/MenSun.jpg',
      (ProductCategory.sunglasses, Audience.women) => 'assets/images/WomenSun.jpg',
      (ProductCategory.sunglasses, Audience.kids) => 'assets/images/KidsSun.jpg',
    };

    final product = FrameProduct(
      id: _id,
      title: _title.text.trim(),
      shape: _shape,
      price: price,
      mrp: mrp,
      imageAsset: asset,
      description: _description.text.trim(),
    );

    final sellerProduct = SellerProduct(
      product: product,
      category: _category,
      audience: _audience,
      imageUrl: _imagePath,
    );

    final ctrl = ProductScope.of(context);
    if (widget.existing == null) { 
      await ctrl.addAndPersist(sellerProduct);
    } else {
      await ctrl.updateAndPersist(sellerProduct);
    }

    if (!mounted) return;

    // Force Profile -> Seller view after save.
    ProfileModeScope.of(context).setMode(ProfileMode.seller);
    rootScaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            widget.existing == null
                ? 'Product added successfully'
                : 'Product updated successfully',
          ),
        ),
      );

    Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        title: Text(
          widget.existing == null ? 'Add Product (Seller)' : 'Edit Product (Seller)',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Basic Info',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
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
                    const Text(
                      'Product Image',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 160,
                        child: _imagePath != null
                            ? Image.network(
                                _imagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                ),
                              )
                            : (_pickedImageBytes != null
                                ? Image.memory(
                                    _pickedImageBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: Icon(Icons.image_outlined, size: 36),
                                    ),
                                  )),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _uploadingImage ? null : _pickAndUploadImage,
                            icon: _uploadingImage
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.upload_outlined),
                            label: Text(_uploadingImage ? 'Uploading...' : 'Upload Image'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          tooltip: 'Remove image',
                          onPressed: _uploadingImage
                              ? null
                              : () {
                                  setState(() {
                                    _imagePath = null;
                                    _pickedImageBytes = null;
                                  });
                                },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Only 1 image. Auto-compressed to under 1MB.',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Product Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 18),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<ProductCategory>(
                value: _category,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ProductCategory.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(_categoryLabel(c)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Audience>(
                value: _audience,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: Audience.values
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text(_audienceLabel(a)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _audience = v ?? _audience),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _shape,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const ['Square', 'Rectangle', 'Aviator', 'Geometric']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _shape = v ?? _shape),
              ),
              const SizedBox(height: 18),
              const Text(
                'Pricing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final txt = (v ?? '').trim();
                  final numVal = double.tryParse(txt);
                  if (txt.isEmpty) return 'Enter price';
                  if (numVal == null || numVal <= 0) return 'Enter valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mrp,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'MRP (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A8A1F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _save,
                child: const Text(
                  'SAVE PRODUCT',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
