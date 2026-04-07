import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/shared/product.dart';
import '../shared/base_dailog.dart';

class WindowsDailogAlert extends StatefulWidget {
  final String title;
  final String body;
  final Product? product; // null = add mode, not null = edit mode

  const WindowsDailogAlert({
    super.key,
    required this.title,
    required this.body,
    this.product,
  });

  @override
  State<WindowsDailogAlert> createState() => _WindowsDailogAlertState();
}

class _WindowsDailogAlertState extends State<WindowsDailogAlert> {


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: '',
        showCard: true,
        titleSize: 18,
        cardHeight: 370,
        cardWidth: 480,
        onClose: () => Navigator.pop(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.title.contains("Out of Stock")
                      ? Icons.error_outline
                      : Icons.warning_amber_rounded,
                  color: widget.title.contains("Out of Stock")
                      ? Colors.red
                      : Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.title.contains("Out of Stock")
                          ? Colors.red
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.body, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            if (widget.product != null) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                "Product Details:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text("• Current Stock: ${widget.product!.stockQuantity}"),
              Text("• Threshold: ${widget.product!.lowStockThreshold}"),
              if (widget.product!.stockQuantity <= 0)
                const Text(
                  "• Status: OUT OF STOCK",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (widget.product!.stockQuantity <= widget.product!.lowStockThreshold)
                const Text(
                  "• Status: LOW STOCK",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "This product requires immediate attention",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Later"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.title.contains("Out of Stock")
                          ? Colors.red
                          : Colors.orange,
                    ),
                    child: const Text("View Product"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}