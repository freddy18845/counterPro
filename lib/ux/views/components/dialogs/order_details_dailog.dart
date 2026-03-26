import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/shared/sale_order.dart';
import '../../../res/app_colors.dart';
import '../screens/savedOrders/detail_row.dart';

class OrderDetailsDialog extends StatelessWidget {
  final SaleOrder order;

  const OrderDetailsDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ${order.orderNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm')
                  .format(order.createdAt),
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey),
            ),
            const Divider(height: 20),

            // items
            const Text('Items',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(item.productName,
                          style:
                          const TextStyle(fontSize: 12))),
                  Expanded(
                      child: Text('x${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey))),
                  Expanded(
                      child: Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500))),
                ],
              ),
            )),

            const Divider(height: 20),

            // totals
            DetailRow(
                label: 'Subtotal',
                value:
                '\$${order.subtotal.toStringAsFixed(2)}'),
            DetailRow(
                label: 'Tax',
                value:
                '\$${order.taxAmount.toStringAsFixed(2)}'),
            DetailRow(
              label: 'Total',
              value: '\$${order.totalAmount.toStringAsFixed(2)}',
              isBold: true,
            ),

            if (order.note != null) ...[
              const SizedBox(height: 8),
              Text('Note: ${order.note}',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
            ],

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}