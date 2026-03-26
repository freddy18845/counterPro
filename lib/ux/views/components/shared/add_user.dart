import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import '../../../../platform/utils/isar_manager.dart';
import '../../../models/shared/pos_user.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_drawables.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/app.dart';
import '../../../utils/shared/screen.dart';
import 'btn.dart';
import 'login_input.dart';

class AddUser extends StatefulWidget {
  final   String? userName ;
  final  String? userEmail;
  final   String? userPassword;
  final   UserRole? selectedRole;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final bool isSetUp;
  const AddUser({super.key,
    this.userName='',
    this.userEmail='',
    this.selectedRole = UserRole.cashier,
    this.userPassword='',
    this.isSetUp =false, required this.onCancel, required this.onNext,
  });

  @override
  State<AddUser> createState() => _AddUserState();
}


class _AddUserState extends State<AddUser> {
  final isar =  IsarService().isar;
  final _formKey = GlobalKey<FormState>();
  UserRole selectedRole = UserRole.cashier;
  TextEditingController  nameController = TextEditingController();
  TextEditingController  emailController = TextEditingController();
  TextEditingController  passwordController = TextEditingController();
  bool isLoading = false;

  void initState() {
    super.initState();
    nameController.text = widget.userName??'';
    emailController.text = widget.userEmail??'';
    passwordController.text = widget.userPassword??'';
    selectedRole = widget.selectedRole??UserRole.cashier;
  }
  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // check if email already exists
    final existing = await isar.posUsers
        .where()
        .filter()
        .emailEqualTo(emailController.text.trim())
        .findFirst();

    if (existing != null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email already exists')),
      );
      return;
    }

    final user = PosUser()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..passwordHash = passwordController.text // hash this in production
      ..role = selectedRole
      ..isActive = true
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.posUsers.put(user);
    });

    setState(() => isLoading = false);
if(!widget.isSetUp){
  AppUtil.toastMessage(message: '✅ User Created successfully', context: context);
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
    return  Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(height: 5),
          Center(
            child: SvgPicture.asset(
              AppDrawables.darkLogoSVG,
              width: 150,
              height: 70,
              fit: BoxFit.fitWidth,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: const Text(
              'Create New User',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          InputField(
            label: 'Full Name',
            controller: nameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
            validator: (v) =>
            v == null || v.isEmpty ? 'Enter name' : null, prexIcon: Icons.person,
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
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
              ).hasMatch(value);
              if (!emailValid) {
                return "Enter a valid email address";
              }
              return null;
            }, prexIcon: Icons.email,
          ),

          const SizedBox(height: 16),

          // password
          InputField(
            label: 'Password',
            controller:passwordController,
            hintText: 'Password',
            enabled: true,
            keyboardType: TextInputType.name,
            showVisibilityToggle: true,
            obscureText: true,
            validator: (v) => v == null || v.length < 4
                ? 'Min 4 characters'
                : null,
            prexIcon: Icons.lock,
          ),
          const SizedBox(height: 16),

          // role dropdown
          Text(
            AppStrings.role,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: (ScreenUtil.width * 0.04).clamp(14.0, 18.0),
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<UserRole>(
            value: selectedRole,
            decoration: InputDecoration(
              enabled: true,
              labelStyle:  const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w200),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:  BorderSide(color: Colors.grey.withAlpha(20)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              prefixIcon: const Icon(Icons.admin_panel_settings,size: 20,color: AppColors.primaryColor,),
            ),
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedRole = val);
            },
          ),

          const SizedBox(height: 16),
          // go to login
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child:    ColorBtn(text: AppStrings.cancel, btnColor:  AppColors.red,action: (){
                widget.onCancel();
              },),),
              SizedBox(width: 24,),
              Expanded(child:   ColorBtn(
                text:isLoading ? AppStrings.saving :AppStrings.save , btnColor:   AppColors.secondaryColor,action: (){
                createUser();
              },))
            ],
          ),

        ],
      ),
    );
  }
}
