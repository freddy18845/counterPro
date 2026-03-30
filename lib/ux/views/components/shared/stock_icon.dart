import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../utils/shared/screen.dart';
import '../../../utils/shared/stock_monitor.dart';

class StockIcon extends StatelessWidget {
  const StockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenUtil.width >= 900;
    return Container(
      height: isDesktop?42:32,
      width: isDesktop?42:32,
      decoration: BoxDecoration(
        color:   Colors.white12,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.8, color: Colors.white)
      ),
      child: StreamBuilder<int>(
        stream: StockMonitorService.lowStockCountStream,
        builder: (context, snapshot) {
          final count = snapshot.data ?? StockMonitorService.currentLowStockCount;
          return Stack(
            children: [
              IconButton(
                icon:  Icon(Icons.notifications,color:Colors.white, size:isDesktop?25:18 ,),
                onPressed: () {
                  AppNavigator.gotoInventory(
                    onIsLowStock: (StockFilter){

                    },
                      context: context,
                      data: ConstantUtil.options[0]);
                  // Show stock alerts
                },
              ),
              if (count > 0)
                Positioned(
                  left: 20,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

  }
}
