import 'package:flutter/material.dart';

import 'PurchaseSheets/shared/frame_product.dart';
import '../db/buyer_profile_repo.dart';
import 'shared/order_controller.dart';
import 'shared/product_image.dart';
import 'shared/screen_entrance.dart';
class BuyerPurchaseScreen extends StatefulWidget {
  final FrameProduct product;
  final int qty;
  final String? imageUrl;

  const BuyerPurchaseScreen({
    super.key,
    required this.product,
    this.qty = 1,
    this.imageUrl,
  });

  @override
  State<BuyerPurchaseScreen> createState() => _BuyerPurchaseScreenState();
}

class _BuyerPurchaseScreenState extends State<BuyerPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileRepo = BuyerProfileRepo();

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  String _paymentMethod = 'Cash on Delivery';
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    _prefillFromSavedAddress();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  Future<void> _prefillFromSavedAddress() async {
    final profile = await _profileRepo.getProfile();
    if (!mounted || profile == null) return;

    if (_name.text.isEmpty) _name.text = profile.name ?? '';
    if (_phone.text.isEmpty) _phone.text = profile.phone ?? '';
    if (_address.text.isEmpty) _address.text = profile.address ?? '';
  }

  Future<void> _confirmOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _placing = true);
    try {
      final qty = widget.qty < 1 ? 1 : widget.qty;
      OrderScope.of(context).placeOrder(
        widget.product,
        qty: qty,
        imageUrl: widget.imageUrl,
        paymentMethod: _paymentMethod,
        isPaid: _paymentMethod != 'Cash on Delivery',
      );

      _toast('Order placed: ${widget.product.title} (x$qty)');
      if (!mounted) return;
      Navigator.pushNamed(context, '/orders');
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _phoneValidator(String? v) {
    final basic = _required(v);
    if (basic != null) return basic;
    if (v!.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Enter valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final qty = widget.qty < 1 ? 1 : widget.qty;
    final total = p.price * qty;

    return ScreenEntrance(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7ED),
          title: const Text('Checkout'),
        ),
        body: AbsorbPointer(
          absorbing: _placing,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// ================= PRODUCT CARD POP =================
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.9, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  builder: (_, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
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
                            width: 72,
                            height: 72,
                            child: ProductImage(
                              assetFallback: p.imageAsset,
                              imageUrl: widget.imageUrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Shape: ${p.shape} • Qty: $qty',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '₹${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= FORM CARD =================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Delivery Details',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: _phoneValidator,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _address,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Full Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 16),

                        const Text('Payment Method',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                        RadioListTile<String>(
                          value: 'Cash on Delivery',
                          groupValue: _paymentMethod,
                          onChanged: (v) =>
                              setState(() => _paymentMethod = v!),
                          title: const Text('Cash on Delivery'),
                        ),
                        RadioListTile<String>(
                          value: 'Online Payment',
                          groupValue: _paymentMethod,
                          onChanged: (v) =>
                              setState(() => _paymentMethod = v!),
                          title: const Text('Online Payment'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= PREMIUM BUTTON =================
                AnimatedScale(
                  scale: _placing ? 0.98 : 1,
                  duration: const Duration(milliseconds: 120),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A8A1F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _placing ? null : _confirmOrder,
                    child: Text(
                      _placing ? 'Placing...' : 'Confirm Order',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
