
import "package:eswaini_destop_app/platform/utils/isar_manager.dart";
import "package:eswaini_destop_app/ux/utils/shared/app.dart";
import "package:flutter/material.dart";
import "../../../models/shared/pos_user.dart";
import "../../../utils/shared/screen.dart";
import "../shared/add_user.dart";
import "../shared/base_dailog.dart";


class AddEditUsersDialog extends StatefulWidget {
  final PosUser? user;

  const AddEditUsersDialog({super.key, this.user, });

  @override
  State<AddEditUsersDialog> createState() => _AddEditUsersDialogState();
}

class _AddEditUsersDialogState extends State<AddEditUsersDialog> {
  final isar = IsarService.db;
  bool get _isEditMode => widget.user?.email != null ;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
        title: _isEditMode ? 'Edit Users' : 'Add Users',
        showCard: true,
        titleSize: 18,
        cardHeight: 520,
        cardWidth: 500,
        onClose: () => Navigator.pop(context),
        child: SizedBox(
          height: 500,
          width: 470,
          child: AddUser(
          user: widget.user,

          isSetUp: false,
          onCancel: (){
            Navigator.pop(context);
          },
          onNext: () {

            AppUtil.toastMessage(
              message:_isEditMode? "Users Created Successful":"Users  Info Updated Successful",
              context: context,
            );
            Navigator.pop(context);
          },
          // final submit on last page
        ),
        )),
    );
  }
}
