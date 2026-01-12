import 'package:flutter/material.dart';

enum SortOption {
  recommended,
  bestsellers,
  newArrivals,
  priceLowToHigh,
  priceHighToLow,
}

class SortBottomSheet extends StatefulWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late SortOption _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.recommended:
        return 'Recommended';
      case SortOption.bestsellers:
        return 'Bestsellers';
      case SortOption.newArrivals:
        return 'New Arrivals';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Indicator
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),

            // Sort Options
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: SortOption.values.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey.shade200,
                indent: 20,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                final option = SortOption.values[index];
                final isSelected = _selectedSort == option;
                final label = _getSortLabel(option);
                final isDefault = option == SortOption.recommended;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedSort = option);
                    widget.onSortSelected(option);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        // Radio Button
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0A8A1F)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF0A8A1F),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),

                        // Label
                        Expanded(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF1A1A2E)
                                  : const Color(0xFF4A4A4A),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        // Default Badge
                        if (isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
