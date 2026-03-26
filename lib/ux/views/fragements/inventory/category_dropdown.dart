import 'package:flutter/material.dart';
import '../../../models/shared/category.dart';
import '../../../res/app_colors.dart';
import '../../../utils/shared/screen.dart';


class CategoryFilterDropdown extends StatelessWidget {
  final Category? selectedCategory;
  final List<Category> categories;
  final Function(Category?) onCategoryChanged;
  final bool isLoading;

  const CategoryFilterDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (ScreenUtil.width * 0.15).clamp(140, 220),
      child: DropdownButtonFormField<Category?>(
        value: selectedCategory,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.category, size: 20, color: Colors.grey),
          suffixIcon: isLoading
              ? const Padding(
            padding: EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
              : null,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        isDense: true,
        hint: const Text(
          'All Categories',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text(
              'All Categories',
              style: TextStyle(fontSize: 13),
            ),
          ),
          ...categories.map((c) => DropdownMenuItem(
            value: c,
            child: Text(
              c.name,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
        onChanged: isLoading ? null : onCategoryChanged,
        dropdownColor: Colors.white,
        menuMaxHeight: 300,
        borderRadius: BorderRadius.circular(8),
        selectedItemBuilder: (context) {
          return [
            Builder(
              builder: (context) => const Text(
                'All Categories',
                style: TextStyle(fontSize: 13),
              ),
            ),
            ...categories.map((c) => Builder(
              builder: (context) => Text(
                c.name,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ];
        },
      ),
    );
  }
}