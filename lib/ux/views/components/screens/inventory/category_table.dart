// ── Categories table ──────────────────────────────────────────
import 'package:eswaini_destop_app/ux/views/components/screens/inventory/table_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../models/shared/category.dart';

class CategoriesTable extends StatelessWidget {
  final Isar isar;
  final bool  isLoading;
  final List<Category> Function(List<Category>) paginate;
  final ValueChanged<int> onTotalChanged;
  final void Function(Category category) onEdit;

  const CategoriesTable({
    required this.isar,
    required this.paginate,
    required this.onTotalChanged, required this.isLoading, required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: isar.categorys
          .where()
          .watch(fireImmediately: true)
          .distinct((a, b) {
        if (a.length != b.length) return false;
        for (int i = 0; i < a.length; i++) {
          if (a[i].id != b[i].id ||
              a[i].updatedAt != b[i].updatedAt) return false;
        }
        return true;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator(radius: 12, color: Colors.grey));
        }
        final all = snapshot.data!;
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => onTotalChanged(all.length));
        final paged = paginate(all);

        if (paged.isEmpty) {
          return const Center(child: Text('No categories found'));
        }

        return Column(
          children: [
            InventoryTableRow(
              isHeader: true,
              cells: const ['Name', 'Description', 'Status'],

            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2),
                itemCount: paged.length,
                addRepaintBoundaries: true,   // ← isolates repaints
                addAutomaticKeepAlives: false, // ← don't keep off-screen items alive
                cacheExtent: 200,
                itemBuilder: (context, index) {
                  final c = paged[index];
                  return InventoryTableRow(
                    isHeader: false,
                    isAlternate: index.isOdd,
                    category: c,              // ← pass category object
                    onCategoryEdit: onEdit,
                    cells: [
                      c.name,
                      c.description ?? '-',
                      c.isActive ? 'Active' : 'Inactive',

                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}