import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../platform/utils/constant.dart';
import '../../../models/shared/wallet/network.dart';
import '../../../res/app_colors.dart';
import '../../../utils/shared/screen.dart';
import '../../components/shared/curve_amount_base.dart';
import '../shared/blink.dart';

class NumberField extends StatefulWidget {
  final WalletNetwork? selectedNetwork;
  final String inputValue;
  final String hint;

  const NumberField({
    super.key,
     this.selectedNetwork,
    required this.inputValue, required this.hint
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late WalletNetwork _selectedNetwork;

  @override
  void initState() {
    super.initState();
    if(widget.selectedNetwork!=null){
      _selectedNetwork = widget.selectedNetwork!;
    }

  }

  // CRITICAL: This allows the UI to update when you type on the keypad
  @override
  void didUpdateWidget(covariant NumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.selectedNetwork!=null){
      if (widget.selectedNetwork != oldWidget.selectedNetwork) {
        _selectedNetwork = widget.selectedNetwork!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use widget.inputValue directly to ensure it updates in real-time
    final String currentPhone = widget.inputValue;

    return
      CurveAmountBase(
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Network Prefix Dropdown
         widget.selectedNetwork !=null? DropdownButton<WalletNetwork>(
            value: _selectedNetwork,
            underline: const SizedBox.shrink(),
            isDense: false,
            itemHeight: ConstantUtil.dropDownItem,
            //isExpanded: true,
            // 1. THIS IS THE KEY: Ensure the selected item has the same size
            selectedItemBuilder: (BuildContext context) {
              return ConstantUtil.networks.map((WalletNetwork network) {
                return Container(
                  width: ConstantUtil.dropDownItem, // Match your desired square size
                  height: ConstantUtil.dropDownItem,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: network.outLineColor),
                    image: DecorationImage(
                      fit: BoxFit.contain, // Contain keeps the logo from touching edges
                      image: AssetImage(network.image),
                    ),
                  ),
                );
              }).toList();
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryColor,
              size: 32,
            ),
            items: ConstantUtil.networks.map((WalletNetwork network) {
              return DropdownMenuItem<WalletNetwork>(
                value: network,
                child: Container(
                  width: ConstantUtil.dropDownItem, // Match your desired square size
                  height: ConstantUtil.dropDownItem-5,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: network.outLineColor),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(network.image),
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (WalletNetwork? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedNetwork = newValue;
                });
              }
            },
          ):SizedBox(),

          // Separator
          widget.selectedNetwork !=null?  SizedBox(
           height: 50,
            child:VerticalDivider(thickness: 0.8,color: Colors.black,)
          ):SizedBox(),

          // Phone Number Display
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      currentPhone.isEmpty || currentPhone=='' ? Text(
                        widget.hint,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: (ScreenUtil.height * 0.045).clamp(10, 12),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ):Text(
                        currentPhone,
                        style: TextStyle(
                          color:  AppColors.primaryColor,
                          fontSize: (ScreenUtil.height * 0.045).clamp(40, 60),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          letterSpacing: 1.5,
                        ),
                      ),

                      // Blinking cursor

                      Icon(
                        Icons.dialpad,
                        color: Colors.black,
                        size: 32,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
     ),
    );
  }
}