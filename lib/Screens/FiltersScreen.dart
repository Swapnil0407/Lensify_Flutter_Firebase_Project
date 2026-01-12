import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _selectedCategory = 'Price';
  final Set<String> _selectedFilters = {};

  final Map<String, List<Map<String, dynamic>>> _filterData = {
    'Price': [
      {'label': '₹1000–₹1999', 'value': '1000-1999'},
      {'label': '₹2000–₹2999', 'value': '2000-2999'},
      {'label': '₹3000–₹3999', 'value': '3000-3999'},
      {'label': '₹4000–₹4999', 'value': '4000-4999'},
      {'label': 'Above ₹5000', 'value': '5000+'},
    ],
    'Gender': [
      {'label': 'Men', 'value': 'men'},
      {'label': 'Women', 'value': 'women'},
      {'label': 'Unisex', 'value': 'unisex'},
      {'label': 'Kids', 'value': 'kids'},
    ],
    'Shape & Style': [
      {'label': 'Square', 'value': 'square'},
      {'label': 'Rectangle', 'value': 'rectangle'},
      {'label': 'Aviator', 'value': 'aviator'},
      {'label': 'Round', 'value': 'round'},
      {'label': 'Cat Eye', 'value': 'cat-eye'},
      {'label': 'Geometric', 'value': 'geometric'},
    ],
    'Frame Size': [
      {'label': 'Narrow (< 130mm)', 'value': 'narrow'},
      {'label': 'Medium (130-140mm)', 'value': 'medium'},
      {'label': 'Wide (> 140mm)', 'value': 'wide'},
    ],
    'Brand': [
      {'label': 'Lenskart', 'value': 'lenskart'},
      {'label': 'John Jacobs', 'value': 'john-jacobs'},
      {'label': 'Vincent Chase', 'value': 'vincent-chase'},
      {'label': 'Oakley', 'value': 'oakley'},
      {'label': 'Ray-Ban', 'value': 'ray-ban'},
    ],
    'Frame Color': [
      {'label': 'Black', 'value': 'black'},
      {'label': 'Brown', 'value': 'brown'},
      {'label': 'Blue', 'value': 'blue'},
      {'label': 'Gold', 'value': 'gold'},
      {'label': 'Silver', 'value': 'silver'},
      {'label': 'Transparent', 'value': 'transparent'},
    ],
    'Material': [
      {'label': 'Metal', 'value': 'metal'},
      {'label': 'Plastic', 'value': 'plastic'},
      {'label': 'Acetate', 'value': 'acetate'},
      {'label': 'Titanium', 'value': 'titanium'},
    ],
    'Weight': [
      {'label': 'Light (< 15g)', 'value': 'light'},
      {'label': 'Medium (15-20g)', 'value': 'medium'},
      {'label': 'Heavy (> 20g)', 'value': 'heavy'},
    ],
    'Occasion': [
      {'label': 'Casual', 'value': 'casual'},
      {'label': 'Formal', 'value': 'formal'},
      {'label': 'Sports', 'value': 'sports'},
      {'label': 'Party', 'value': 'party'},
    ],
  };

  void _clearAll() {
    setState(() {
      _selectedFilters.clear();
    });
  }

  void _applyFilters() {
    Navigator.pop(context, _selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _filterData.keys.toList();
    final currentFilters = _filterData[_selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Row(
        children: [
          // Left Side - Categories
          Container(
            width: 140,
            color: Colors.grey.shade50,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? const Color(0xFF0A8A1F)
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFF6A6A6A),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Right Side - Filter Options
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Price includes lens tag
                      if (_selectedCategory == 'Price')
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PRICE INCLUDES LENS',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Filter Options
                      ...currentFilters.map((filter) {
                        final value = '${_selectedCategory}_${filter['value']}';
                        final isSelected = _selectedFilters.contains(value);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFilters.remove(value);
                              } else {
                                _selectedFilters.add(value);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: [
                                // Checkbox with check icon
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF0A8A1F)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF0A8A1F)
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 14),

                                // Label
                                Expanded(
                                  child: Text(
                                    filter['label'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFF1A1A2E)
                                          : const Color(0xFF4A4A4A),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Clear All Button
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearAll,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Apply Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A2E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply${_selectedFilters.isEmpty ? '' : ' (${_selectedFilters.length})'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
