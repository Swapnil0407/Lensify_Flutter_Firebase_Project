import 'package:flutter/material.dart';

import 'frame_product.dart';
import '../../BuyerPurchaseScreen.dart';
import '../../shared/cart_controller.dart';

class FramePurchaseSheet extends StatefulWidget {
  final FrameProduct product;

  final List<String> colors;
  final List<String> sizes;
  final List<String> lensTypes;
  final String lensTypeLabel;

  const FramePurchaseSheet({
    super.key,
    required this.product,
    this.colors = const ['Black', 'Brown', 'Blue', 'Transparent'],
    this.sizes = const ['Small', 'Medium', 'Large'],
    this.lensTypes = const [
      'Frame Only',
      'Single Vision',
      'Blue Cut',
      'Progressive',
    ],
    this.lensTypeLabel = 'Lens Type',
  });

  @override
  State<FramePurchaseSheet> createState() => _FramePurchaseSheetState();
}

class _FramePurchaseSheetState extends State<FramePurchaseSheet> {
  late String _color = widget.colors.first;
  late String _size = widget.sizes.length > 1 ? widget.sizes[1] : widget.sizes.first;
  late String _lensType = widget.lensTypes.first;
  int _qty = 1;

  double? get _discountPercent {
    final mrp = widget.product.mrp;
    if (mrp == null || mrp <= widget.product.price) return null;
    return ((mrp - widget.product.price) / mrp) * 100.0;
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 92,
                      height: 92,
                      color: Colors.grey.shade100,
                      child: Image.asset(
                        p.imageAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported_outlined),
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Shape: ${p.shape}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '₹${p.price.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 10),
                            if (p.mrp != null && p.mrp! > p.price)
                              Text(
                                '₹${p.mrp!.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.black54,
                                    ),
                              ),
                            const SizedBox(width: 8),
                            if (_discountPercent != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${_discountPercent!.toStringAsFixed(0)}% OFF',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Options', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              _OptionRow(
                label: 'Color',
                child: DropdownButton<String>(
                  value: _color,
                  isExpanded: true,
                  items: widget.colors
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _color = v ?? _color),
                ),
              ),
              _OptionRow(
                label: 'Size',
                child: DropdownButton<String>(
                  value: _size,
                  isExpanded: true,
                  items: widget.sizes
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _size = v ?? _size),
                ),
              ),
              const SizedBox(height: 8),
              Text(widget.lensTypeLabel,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.lensTypes.map((t) {
                  return ChoiceChip(
                    label: Text(t),
                    selected: _lensType == t,
                    onSelected: (_) => setState(() => _lensType = t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Quantity', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: _qty <= 1 ? null : () => setState(() => _qty -= 1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_qty', style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    onPressed: () => setState(() => _qty += 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text('Description', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(p.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        CartScope.of(context).add(p, qty: _qty);
                        _toast('Added to cart: ${p.title} (x$_qty)');
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final nav = Navigator.of(context);
                        nav.pop();
                        nav.push(
                          MaterialPageRoute(
                            builder: (_) => BuyerPurchaseScreen(
                              product: p,
                              qty: _qty,
                            ),
                          ),
                        );
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _OptionRow({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label)),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}
