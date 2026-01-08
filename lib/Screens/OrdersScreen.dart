import 'package:flutter/material.dart';

import 'shared/order_controller.dart';
import 'shared/product_image.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _etaText(DateTime eta) {
    final now = DateTime.now();
    final diff = eta.difference(now);
    final days = diff.inDays;
    if (days <= 0) return 'Arriving today';
    if (days == 1) return 'Arriving in 1 day';
    return 'Arriving in $days days';
  }

  @override
  Widget build(BuildContext context) {
    final controller = OrderScope.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7ED),
          title: const Text('My Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Order in Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final orders = controller.orders;
            final inProgress = orders.where((o) => !o.isDelivered).toList();
            final completed = orders.where((o) => o.isDelivered).toList();

            return TabBarView(
              children: [
                _OrdersList(
                  items: inProgress,
                  emptyText: 'No orders in progress',
                  subtitleBuilder: (o) =>
                      '${_etaText(o.eta)} • Ordered ${_formatDate(o.orderedAt)}',
                  trailingBuilder: (o) => const _OrderStatusChip(text: 'In Progress'),
                  detailsBuilder: (o) => _OrderTimingDetails(eta: o.eta),
                ),
                _OrdersList(
                  items: completed,
                  emptyText: 'No completed orders',
                  subtitleBuilder: (o) {
                    final deliveredOn = o.deliveredOn;
                    return deliveredOn == null
                        ? 'Delivered'
                        : 'Delivered ${_formatDate(deliveredOn)}';
                  },
                  trailingBuilder: (o) => const _OrderStatusChip(text: 'Delivered'),
                  detailsBuilder: (o) => null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<OrderItem> items;
  final String emptyText;
  final String Function(OrderItem o) subtitleBuilder;
  final Widget Function(OrderItem o) trailingBuilder;
  final Widget? Function(OrderItem o) detailsBuilder;

  const _OrdersList({
    required this.items,
    required this.emptyText,
    required this.subtitleBuilder,
    required this.trailingBuilder,
    required this.detailsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final o = items[i];
        final details = detailsBuilder(o);

        return Container(
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: ProductImage(
                        assetFallback: o.assetFallback,
                        imageUrl: o.imageUrl,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitleBuilder(o),
                          style: const TextStyle(color: Colors.black54),
                        ),
                        if (o.qty > 1) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Qty: ${o.qty}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          '${o.paymentMethod} • ${o.isPaid ? 'Paid' : 'To Pay'} • Payable: ₹${(o.price * o.qty).toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${(o.price * o.qty).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  trailingBuilder(o),
                ],
              ),
              if (details != null) ...[
                const SizedBox(height: 12),
                details,
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  final String text;

  const _OrderStatusChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A8A1F).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF0A8A1F).withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0A8A1F),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OrderTimingDetails extends StatelessWidget {
  final DateTime eta;

  const _OrderTimingDetails({required this.eta});

  @override
  Widget build(BuildContext context) {
    // UI-only: show a simple breakdown like marketplaces.
    // Seller processing -> Shipping -> Out for delivery.
    final now = DateTime.now();
    final totalHours = eta.difference(now).inHours;
    final sellerHours = (totalHours * 0.35).clamp(6, 48).toInt();
    final shippingHours = (totalHours * 0.45).clamp(12, 72).toInt();
    final lastMileHours = (totalHours - sellerHours - shippingHours).clamp(6, 48).toInt();

    String h(int hours) {
      if (hours <= 24) return '$hours hrs';
      final d = (hours / 24).ceil();
      return '$d day${d == 1 ? '' : 's'}';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated time (Seller → Buyer)',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          _Row(label: 'Seller processing', value: h(sellerHours)),
          _Row(label: 'Shipping', value: h(shippingHours)),
          _Row(label: 'Out for delivery', value: h(lastMileHours)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
