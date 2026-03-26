import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/views/fragements/home/transaction_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../platform/utils/constant.dart';
import '../../../blocs/screens/home/bloc.dart';

class ScrollableTransactionsRow extends StatefulWidget {
  final HomeBloc homeBloc;
  final String selectedTransaction;
  final Function(String) onSelect;

  const ScrollableTransactionsRow({
    super.key,
    required this.homeBloc,
    required this.selectedTransaction,
    required this.onSelect,
  });

  @override
  State<ScrollableTransactionsRow> createState() =>
      _ScrollableTransactionsRowState();
}

class _ScrollableTransactionsRowState
    extends State<ScrollableTransactionsRow> {
  final ScrollController _controller = ScrollController();

  void _scrollLeft() {
    final double newOffset = (_controller.offset - 200)
        .clamp(0.0, _controller.position.maxScrollExtent)
        .toDouble();

    _controller.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    final double newOffset = (_controller.offset + 200)
        .clamp(0.0, _controller.position.maxScrollExtent)
        .toDouble();

    _controller.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
        alignment: Alignment.center,
        children: [
          /// 🔥 SCROLLABLE ROW
          SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children:
              ConstantUtil.options.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () async {
                      widget.onSelect(item.text);

                      await Future.delayed(
                          const Duration(milliseconds: 100));

                      widget.homeBloc.add(
                        HomeBaseSecStartFlow(item: item),
                      );
                    },
                    child: TransactionCard(
                      item: item,
                      title: widget.selectedTransaction,
                    )
                        .animate()
                        .fadeIn(
                      delay:
                      Duration(milliseconds: 150 * index),
                      duration: 500.ms,
                    )
                        .slideY(
                      begin: 0.2,
                      end: 0,
                      curve: Curves.easeOutQuad,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          /// ⬅ LEFT ARROW
          Positioned(
            left: 0,
            child: _arrowButton(
              icon: Icons.chevron_left,
              onTap: _scrollLeft,
            ),
          ),

          /// ➡ RIGHT ARROW
          Positioned(
            right: 0,
            child: _arrowButton(
              icon: Icons.chevron_right,
              onTap: _scrollRight,
            ),
          ),
        ],

    );
  }

  Widget _arrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color:Colors.black12.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.secondaryColor),
        onPressed: onTap,
      ),
    );
  }
}