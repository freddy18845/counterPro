import "dart:async";

import "package:eswaini_destop_app/platform/utils/constant.dart";
import "package:flutter/material.dart";
import "../../../res/app_colors.dart";
import "../../../res/app_strings.dart";
import "../../../utils/shared/screen.dart";
import "../shared/base_dailog.dart";

class NetworkDialog extends StatefulWidget {
  const NetworkDialog({super.key});

  @override
  State<NetworkDialog> createState() => _NetworkDialogState();
}

class _NetworkDialogState extends State<NetworkDialog> {
  int? _selectedIndex;




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: AppStrings.selectMobileNetworkToProceed,
        showCard: true,
        onClose: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: (ScreenUtil.width * 0.02).clamp(500, 620),
              child: Row(
                spacing: 4,
                children: ConstantUtil.networks.asMap().entries.map((item) {
                  final isSelected = _selectedIndex == item.key;
                  final hasSelection = _selectedIndex != null;
                  final opacity = hasSelection && !isSelected ? 0.5 : 1.0;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = item.key;
                        });
                      },
                      child: AnimatedOpacity(
                        opacity: opacity,
                        duration: Duration(milliseconds: 300),
                        child:

                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: (ScreenUtil.height * 0.08).clamp(83, 95), // Match your desired square size
                              height:(ScreenUtil.height * 0.08).clamp(83, 95),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 5,    color: isSelected
                                    ? AppColors.green
                                    : (item.value.outLineColor == Colors.white
                                    ? item.value.outLineColor
                                    : item.value.outLineColor.withValues(
                                  alpha: 0.5,
                                )),),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(item.value.image),
                                ),
                              ),
                            ),
                            // Check icon at bottom of outline
                            if (isSelected)
                              Positioned(
                                bottom: -4,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Buttons row
            Container(
              width: (ScreenUtil.width * 0.02).clamp(400, 520),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                spacing: 12,
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Proceed Button
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _selectedIndex != null ? 1.0 : 0.5,
                      duration: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: _selectedIndex != null
                            ? () {
                                final selectedNetwork =
                                    ConstantUtil.networks[_selectedIndex!];
                                Navigator.pop(context, selectedNetwork);
                              }
                            : null,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedIndex != null
                                ? AppColors.green
                                : AppColors.green.withValues(alpha: 0.3),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppStrings.done,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
