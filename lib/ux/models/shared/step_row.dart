// ── Step row helper ───────────────────────────────────────────
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepRow extends StatelessWidget {
  final String number;
  final String text;
  final bool done;
  final Color color;

  const StepRow({
    required this.number,
    required this.text,
    required this.done,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: done ? Colors.green : color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check,
                size: 14, color: Colors.white)
                : Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: done ? Colors.grey : Colors.black87,
                decoration: done
                    ? TextDecoration.lineThrough
                    : null,
              )),
        ),
      ],
    );
  }
}