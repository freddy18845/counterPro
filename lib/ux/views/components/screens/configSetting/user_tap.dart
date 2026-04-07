// ─────────────────────────────────────────────────────────────
// ── USERS TAB ─────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/user_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../../models/shared/pos_user.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/sessionManager.dart';
import '../../../../utils/shared/app.dart';
import '../../shared/add_user.dart';
import '../../shared/base_dailog.dart';
import '../../shared/btn.dart';

class UsersTab extends StatefulWidget {
  final Isar isar;
  const UsersTab({required this.isar});

  @override
  State<UsersTab> createState() => UsersTabState();
}

class UsersTabState extends State<UsersTab> {
  List<PosUser> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await widget.isar.posUsers.where().findAll();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _showUserDialog({PosUser? user}) async {
    await AppUtil.displayDialog(
      context: context,
      dismissible: false,
      child: UserDialog( user: user),
    );
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle(title: 'System Users'),
            if (SessionManager().isAdmin)
              SizedBox(
                width: 120,
                child: Btn(
                  onTap: () => _showUserDialog(),
                  text: 'Add User',
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (_isLoading)
          Center(
              child: CircularProgressIndicator(
                  color: AppColors.primaryColor, strokeWidth: 2))
        else if (_users.isEmpty)
          const Center(
              child: Text('No users found',
                  style: TextStyle(color: Colors.grey)))
        else
          Expanded(
            child: Column(
              children: [
                // header
                UserRow(
                  isHeader: true,
                  cells: const [
                    'Name',
                    'Email',
                    'Role',
                    'Status',
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _users.length,
                    addRepaintBoundaries: true,   // ← isolates repaints
                    addAutomaticKeepAlives: false, // ← don't keep off-screen items alive
                    cacheExtent: 200,
                    itemBuilder: (context, index) {
                      final u = _users[index];
                      return UserRow(
                        isHeader: false,
                        isAlternate: index.isOdd,
                        user: u,
                        cells: [
                          u.name,
                          u.email,
                          u.role.name[0].toUpperCase() +
                              u.role.name.substring(1),
                          u.isActive ? 'Active' : 'Inactive',
                        ],
                        onEdit: () => _showUserDialog(user: u),
                        onToggle: SessionManager().userId != u.id
                            ? () async {
                          await widget.isar
                              .writeTxn(() async {
                            u.isActive = !u.isActive;
                            u.updatedAt = DateTime.now();
                            await widget.isar.posUsers
                                .put(u);
                          });
                          _loadUsers();
                        }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── User dialog using your DialogBaseLayout ───────────────────
class UserDialog extends StatefulWidget {

  final PosUser? user;

  const UserDialog({ this.user});

  @override
  State<UserDialog> createState() => UserDialogState();
}

class UserDialogState extends State<UserDialog> {

  bool get _isEdit => widget.user != null;




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DialogBaseLayout(
          title: _isEdit ? 'Edit User' : 'Add User',
          showCard: true,
          titleSize: 14,
          cardHeight: 500,
          cardWidth: 500,
          onClose: () => Navigator.pop(context),
          child:
          SizedBox(
            height: 470,
            width: 470,
            child:  AddUser(
                user: widget.user,
                isSetUp: _isEdit?false:true,
                onCancel:  () => Navigator.pop(context),
                onNext:(){
                  Navigator.pop(context, true);
                }),
          )
      ),
    );
  }
}