import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../../platform/utils/isar_manager.dart';
import '../../../models/shared/pos_user.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/sessionManager.dart';
import '../../../utils/shared/app.dart';
import '../../../utils/shared/screen.dart';
import '../../../utils/shared/subscriptionManger.dart';
import 'btn.dart';
import 'login_input.dart';

class AddUser extends StatefulWidget {
  final String? title;
  final PosUser? user;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final bool isSetUp;
  const AddUser({
    super.key,
    this.isSetUp = false,
    required this.onCancel,
    required this.onNext,
    this.title = '', this.user,
  });

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final isar = IsarService().isar;
  final _formKey = GlobalKey<FormState>();
  UserRole selectedRole = UserRole.admin;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isActive = true;
  bool isLoading = false;
  bool get _isEdit => widget.user != null;
  void initState() {
    super.initState();
    if (_isEdit) {
      nameController.text = widget.user!.name;
      emailController.text = widget.user!.email;
      selectedRole = widget.user!.role;
      isActive = widget.user!.isActive;
    }
  }

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // check if email already exists
    final existing = await isar?.posUsers
        .where()
        .filter()
        .emailEqualTo(emailController.text.trim())
        .findFirst();

    if (existing != null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email already exists')));
      return;
    }

    final user = PosUser()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..passwordHash = passwordController
          .text // hash this in production
      ..role = selectedRole
      ..isActive = isActive
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar?.writeTxn(() async {
      await isar?.posUsers.put(user);
    });

    setState(() => isLoading = false);

      if (mounted) {
        AppUtil.toastMessage(
          message: _isEdit
              ? '✅ User updated'
              : '✅ User created successfully',
          context: context,
          backgroundColor: Colors.green,
        );
      await SessionManager().refreshCompany(context);
    }
    widget.onNext();

    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding:  EdgeInsets.all( widget.title!.isNotEmpty?24:16),
        children: [
          widget.title!.isNotEmpty
              ? Center(
                  child: Text(
                    widget.title ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : SizedBox(),
           SizedBox(height: widget.title!.isNotEmpty
              ?  8:0),
          InputField(
            label: 'Full Name',
            controller: nameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
            validator: (v) => v == null || v.isEmpty ? 'Enter Name' : null,
            prexIcon: Icons.person,
          ),

          // name
          const SizedBox(height: 16),

          // email
          InputField(
            label: 'Email',
            controller: emailController,
            hintText: 'Email',
            enabled: true,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value);
              if (!emailValid) {
                return "Enter a valid email address";
              }
              return null;
            },
            prexIcon: Icons.email,
          ),

          const SizedBox(height: 16),
Row(

  children: [
  Expanded(
    flex: 2,
    child:  InputField(
    label: _isEdit
        ? 'New Password (leave blank to keep)'
        : 'Password',
    controller: passwordController,
    hintText: 'Enter password',
    prexIcon: Icons.lock_outlined,
    obscureText: true,
    showVisibilityToggle: true,
    validator: (v) {
      if (!_isEdit && (v == null || v.length < 4)) {
        return 'Min 4 characters';
      }
      return null;
    },
  ),),
 SizedBox(width: 12,),
  Expanded(child:  Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStrings.status,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: (ScreenUtil.width * 0.04).clamp(12.0, 14.0),
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 12,),
      GestureDetector(
        onTap: () =>
            setState(() => isActive = !isActive),
        child:RepaintBoundary(
          child: AnimatedContainer(
          duration:
          const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.green
                .withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isActive
                    ? Colors.green
                    : Colors.red),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                size: 14,
                color: isActive
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        )),
      ),
    ],),),

],),
          // password


          const SizedBox(height: 16),

          // role dropdown
          Text(
            AppStrings.role,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: (ScreenUtil.width * 0.04).clamp(12.0, 14.0),
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: UserRole.values.map((role) {
              final isSelected = selectedRole == role;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedRole = role),
                  child:RepaintBoundary(
                    child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      right: role == UserRole.cashier ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      role.name[0].toUpperCase() + role.name.substring(1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.black,
                      ),
                    ),
                  )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // go to login
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ColorBtn(
                  text: AppStrings.cancel,
                  btnColor: AppColors.red,
                  action: () {
                    widget.onCancel();
                  },
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: ColorBtn(
                  text: isLoading ? AppStrings.saving : AppStrings.save,
                  btnColor: AppColors.secondaryColor,
                  action: () async {
                    // if(!widget.isSetUp){
                    //   final canAdd = await SubscriptionManager().canAddUser();
                    //   if (!canAdd) {
                    //     AppUtil.toastMessage(
                    //       message: 'User limit reached (${SubscriptionManager().maxUsers}). Upgrade your plan.',
                    //       context: context,
                    //       backgroundColor: Colors.red,
                    //     );
                    //     return;
                    //   }
                    // }
                    createUser();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
