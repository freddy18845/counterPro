import 'package:eswaini_destop_app/ux/models/screens/home/flow_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../platform/utils/constant.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/screen.dart';
import '../../components/dialogs/name_lookUp.dart';
import '../../components/shared/btn.dart';
import '../../components/shared/inline_text.dart';
import '../../components/shared/numpad.dart';
import '../wallet/input_field.dart';

class RecipientAccountSection extends StatefulWidget {
  final HomeFlowItem data;
  final Function(String accountNo) onTap;
  final VoidCallback onCancel;
  const RecipientAccountSection({
    super.key,
    required this.onTap,
    required this.onCancel,
    required this.data,
  });

  @override
  State<RecipientAccountSection> createState() =>
      _RecipientAccountSectionState();
}

class _RecipientAccountSectionState extends State<RecipientAccountSection> {
  String _recipientAccountNumber = '';
 @override
  void initState() {
    // TODO: implement initState
   setState(() {
     _recipientAccountNumber = widget.data.beneficiaryAccount;
   });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Column(
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
          inputValue: _recipientAccountNumber,
          hint: AppStrings.enterRecipientAccountNumber,
        ),
        SizedBox(height: ConstantUtil.verticalSpacing),
        Expanded(
          child: NumPad(
            limit: 13,
            key: ValueKey('recipientAccount-numpad'),
            initialValue: _recipientAccountNumber,
            isAmount: false,
            onInput: (String value) {
              setState(() {
                _recipientAccountNumber = value;
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
                  widget.onCancel();
                },
              ),
            ),
            SizedBox(width: ConstantUtil.horizontalSpacing),
            Expanded(
              child: Btn(
                isActive: true,
                bgImage: AppDrawables.blueCard,
                text: AppStrings.verify,
                onTap: () async {
                  final bool? result = await showDialog<bool>(
                    context: context,
                    builder: (context) => const NameLookUpDialog(),
                  );
                  if (result == true) {
                    widget.onTap(_recipientAccountNumber);
                  }

                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
