import 'package:flutter/material.dart';

class ResultCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;

  const ResultCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(categories.length, (i) {
          final bool selected = selectedCategory == i;
          return Padding(
            padding: EdgeInsets.only(right: i < categories.length - 1 ? 12 : 0),
            child: ChoiceChip(
              label: Text(
                categories[i],
                style: TextStyle(
                  color: selected ? Colors.black : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selected,
              selectedColor: Colors.grey[200],
              backgroundColor: Colors.grey[100],
              onSelected: (_) => onCategorySelected(i),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            ),
          );
        }),
      ),
    );
  }
}