import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../platform/utils/constant.dart';
import '../../../blocs/shared/processing/event.dart';
import '../../../blocs/shared/wallet/bloc.dart';
import '../../../models/shared/wallet/network.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/app.dart';
import '../../../utils/shared/screen.dart';
import '../../fragements/wallet/input_field.dart';
import '../shared/btn.dart';
import '../shared/curve_amount_base.dart';
import '../shared/inline_text.dart';
import '../shared/numpad.dart';
import '../shared/processing_card.dart';
import '../../fragements/shared/blink.dart';

class WalletSection extends StatefulWidget {
  final HomeFlowItem data;
  final Function(HomeFlowItem? value) onTap;
  final Function(HomeFlowItem? data) onExist;
  const WalletSection({
    super.key,
    required this.data,
    required this.onTap,
    required this.onExist,
  });

  @override
  State<WalletSection> createState() => _WalletSectionState();
}

class _WalletSectionState extends State<WalletSection> {
  late WalletBloc walletBloc;
  String _phoneNumber = '';
  WalletNetwork _selectedNetwork = ConstantUtil.networks[0];
   late HomeFlowItem updateData;
  @override
  void initState() {
    super.initState();
    walletBloc = context.read<WalletBloc>();
    walletBloc.init(context: context, data: widget.data);
    _selectedNetwork = widget.data.walletNetwork;
    updateData = widget.data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get _isValidPhoneNumber {
    // Validate phone number (adjust based on your requirements)
    // Example: must be 10 digits
    return _phoneNumber.length >= 9 && _phoneNumber.length <= 12;
  }

  _handleSubmit() {
    if (!_isValidPhoneNumber) {
      AppUtil.toastMessage(
        context: context,
        message: "Please enter a valid phone number",
      );
      return;
    }

    updateData.pan = _phoneNumber;
    updateData.walletNetwork = _selectedNetwork;
    widget.onTap(updateData);
    // Add event to process wallet transaction
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      // Listener for side effects (navigation, dialogs, toasts)
      listener: (context, state) {},

      // Builder for UI updates
      builder: (context, state) {
        // Default state
        return CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and tender type
              Row(
                children: [
                  Text(
                    widget.data.text,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
                      fontWeight: FontWeight.w900,
                      //fontFamily: 'Gilroy',
                    ),
                  ),
                  Container(
                    height: 12,
                    width: 0.8,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.primaryColor,
                  ),
                  Text(
                    widget.data.paymentType.description,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: (ScreenUtil.height * 0.02).clamp(9, 12),
                      fontWeight: FontWeight.w200,
                      // fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
              SizedBox(height: ConstantUtil.verticalSpacing / 2),
              SizedBox(
                width: double.infinity,
                child: Divider(thickness: 1.5, color: AppColors.secondaryColor),
              ),
              SizedBox(height: ConstantUtil.verticalSpacing),
              NumberField(
                selectedNetwork: _selectedNetwork,
                inputValue: _phoneNumber,
                hint: AppStrings.enterWalletNumber,
              ),
              SizedBox(height: ConstantUtil.verticalSpacing),
              Expanded(
                child: NumPad(
                  limit: 10,
                  key: ValueKey('wallet-numpad'),
                  initialValue: _phoneNumber,
                  isAmount: false,
                  onInput: (String value) {
                    setState(() {
                      _phoneNumber = value;
                    });

                    // Call the callback
                    // widget.onTap(double.parse(parsed));
                  },
                ),
              ),
              SizedBox(height: ConstantUtil.verticalSpacing / 2),

              InlineText(title: AppStrings.selectAnAction),

              SizedBox(height: ConstantUtil.verticalSpacing),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Btn(
                      isActive: true,
                      bgImage: AppDrawables.redCard,
                      text: AppStrings.cancel,
                      onTap: () {
                        widget.onExist(updateData);
                      },
                    ),
                  ),
                  SizedBox(width: ConstantUtil.horizontalSpacing),
                  Expanded(
                    child: Btn(
                      isActive: true,
                      bgImage: AppDrawables.blueCard,
                      text: AppStrings.approved,
                      onTap: _handleSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
