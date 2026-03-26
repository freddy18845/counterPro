import 'dart:io';
import 'dart:math';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import '../../../../platform/utils/isar_manager.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../utils/shared/app.dart';
import 'btn.dart';
import 'login_input.dart';
import 'package:eswaini_destop_app/ux/models/shared/company.dart';

class CreateCompany extends StatefulWidget {
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final bool isSetUp;
  const CreateCompany({
    super.key,
    required this.onCancel,
    required this.onNext,
    this.isSetUp = false, required this.title,
  });

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final isar = IsarService().isar;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final sloganController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final contactOneController = TextEditingController();
  final contactTwoController = TextEditingController();

  File? _pickedLogo; // Logo image
  bool isLoading = false;
  bool _isFetching = true;
  Company? _company;

  @override
  void initState() {
    super.initState();
    if(!widget.isSetUp){
      _loadCompany();
    }

  }

  Future<void> _loadCompany() async {
    final company =
    await isar.companys.where().findFirst();
    if (company != null) {
      _company = company;
      nameController.text = company.name;
      sloganController.text = company.slogan ?? '';
      emailController.text = company.email;
      addressController.text = company.address;
      contactOneController.text = company.contactOne;
      contactTwoController.text = company.contactTwo;
    }
    setState(() => _isFetching = false);
  }

  /// Pick logo from gallery
  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      setState(() => _pickedLogo = File(pickedFile.path));
    }
  }

  Future<void> createCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final company = Company()
      ..name = nameController.text.trim()
      ..slogan = sloganController.text.trim()
      ..email = emailController.text.trim()
      ..address = addressController.text.trim()
      ..contactOne = contactOneController.text.trim()
      ..contactTwo = contactTwoController.text.trim()
      ..logoPath = _pickedLogo?.path
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    if (widget.isSetUp) {
      final lettersOnly = nameController.text
          .replaceAll(RegExp(r'[^a-zA-Z]'), '')
          .toUpperCase();

      final prefix = lettersOnly.isEmpty
          ? 'TXN'
          : lettersOnly.length >= 3
          ? lettersOnly.substring(0, 3)
          : lettersOnly.padRight(3, 'X');

      // 🎲 generate random 3-digit number (100–999)
      final randomNumber = (Random().nextInt(900) + 100);

      company.companyId = "$prefix$randomNumber";

      company.subscriptionEndDate =
          DateTime.now().add(const Duration(days: 60));
    }

    await isar.writeTxn(() async {
      await isar.companys.put(company); // make sure collection is correct
    });
    nameController.text = '';
    sloganController.text = '';
    emailController.text = '';
    addressController.text = '';
    contactOneController.text = '';
    contactTwoController.text = '';
    setState(() => isLoading = false);
    if (!widget.isSetUp) {
      AppUtil.toastMessage(
        message: 'Company Created Successfully!',
        context: context,
      );
    }

    widget.onNext();
    nameController.clear();
    sloganController.clear();
    emailController.clear();
    addressController.clear();
    contactOneController.clear();
    contactTwoController.clear();
    setState(() => _pickedLogo = null);
  }

  @override
  void dispose() {
    nameController.dispose();
    sloganController.dispose();
    emailController.dispose();
    addressController.dispose();
    contactOneController.dispose();
    contactTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return Center(
          child:  CupertinoActivityIndicator(radius: 18, color: Colors.green));
    }
    return Form(
      key: _formKey,
      child: ListView(
        padding:  EdgeInsets.all( widget.isSetUp?24:12),
        children: [
          widget.isSetUp? Center(
            child: Text(
           widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor
              ),
            ),
          ):SizedBox(),
           SizedBox(height:  widget.isSetUp? 8:0),
          // NAME
          InputField(
            label: 'Company Name',
            controller: nameController,
            hintText: 'Enter company name',
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter company name' : null,
            prexIcon: Icons.business,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Address',
                  controller: addressController,
                  hintText: 'Enter company address',
                  prexIcon: Icons.location_on,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputField(
                  label: 'Email',
                  controller: emailController,
                  hintText: 'Enter company email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Enter email";
                    final emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) return "Enter a valid email";
                    return null;
                  },
                  prexIcon: Icons.email,
                ),
              ),
            ],
          ),

          // SLOGAN

          // EMAIL
          const SizedBox(height: 16),

          // ADDRESS
          InputField(
            label: 'Slogan',
            controller: sloganController,
            hintText: 'Optional slogan',
            prexIcon: Icons.speaker_notes,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Primary Contact',
                  controller: contactOneController,
                  hintText: 'Enter primary contact',
                  prexIcon: Icons.phone,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputField(
                  label: 'Secondary Contact',
                  controller: contactTwoController,
                  hintText: 'Enter secondary contact',
                  prexIcon: Icons.phone_android,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          // CONTACTS
          const SizedBox(height: 16),
          // LOGO UPLOAD
          GestureDetector(
            onTap: pickLogo,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _pickedLogo != null
                  ? Image.file(_pickedLogo!, fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload_file, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Optional:Tap to upload logo',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: ColorBtn(
                  text: AppStrings.cancel,
                  btnColor: AppColors.red,
                  action: () {
                    nameController.text = '';
                    sloganController.text = '';
                    emailController.text = '';
                    addressController.text = '';
                    contactOneController.text = '';
                    contactTwoController.text = '';

                    widget.onCancel();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ColorBtn(
                  text: isLoading ? AppStrings.saving :widget.isSetUp? AppStrings.save:AppStrings.updatingData,
                  btnColor: AppColors.secondaryColor,
                  action: createCompany,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
