import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = ((currentPage - 1) * pageSize) + 1;
    final end = (currentPage * pageSize).clamp(0, totalItems);
    final rangeStart = (currentPage - 2).clamp(1, totalPages);
    final rangeEnd = (currentPage + 2).clamp(1, totalPages);
    final pages = [for (int i = rangeStart; i <= rangeEnd; i++) i];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            totalItems == 0
                ? 'No results'
                : 'Showing $start–$end of $totalItems',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (totalPages > 1)
            Row(
              children: [
                _PBtn(
                  icon: Icons.chevron_left,
                  enabled: currentPage > 1,
                  onTap: () => onPageChanged(currentPage - 1),
                ),
                const SizedBox(width: 4),
                if (rangeStart > 1) ...[
                  _PNum(
                      page: 1,
                      isActive: currentPage == 1,
                      onTap: onPageChanged),
                  if (rangeStart > 2)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('...',
                          style: TextStyle(color: Colors.grey)),
                    ),
                ],
                ...pages.map((p) => _PNum(
                  page: p,
                  isActive: currentPage == p,
                  onTap: onPageChanged,
                )),
                if (rangeEnd < totalPages) ...[
                  if (rangeEnd < totalPages - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('...',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  _PNum(
                      page: totalPages,
                      isActive: currentPage == totalPages,
                      onTap: onPageChanged),
                ],
                const SizedBox(width: 4),
                _PBtn(
                  icon: Icons.chevron_right,
                  enabled: currentPage < totalPages,
                  onTap: () => onPageChanged(currentPage + 1),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PNum extends StatelessWidget {
  final int page;
  final bool isActive;
  final ValueChanged<int> onTap;

  const _PNum({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(page),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? AppColors.primaryColor
                : Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 12,
              fontWeight:
              isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _PBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: enabled
                ? Colors.grey.withOpacity(0.4)
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? Colors.black87 : Colors.grey.withOpacity(0.4),
        ),
      ),
    );
  }
}