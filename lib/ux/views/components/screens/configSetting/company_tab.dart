import 'package:eswaini_destop_app/platform/utils/isar_manager.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/tax_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../res/app_colors.dart';
import '../../../../utils/shared/app.dart';
import '../../../../utils/shared/screen.dart';
import '../../shared/btn.dart';
import '../../shared/create_company.dart';
import '../../shared/login_input.dart';

class CompanyTab extends StatefulWidget {
  const CompanyTab({super.key});

  @override
  State<CompanyTab> createState() => CompanyTabState();
}

class CompanyTabState extends State<CompanyTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Company info ──────────────────────────────
         Expanded(child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [

           SectionTitle(title: 'Company Information'),
           SizedBox(
             width: 600,
             height: (ScreenUtil.height * 0.9).clamp(600, 650),
             child: CreateCompany(
               isSetUp: false,
               onCancel: () => Navigator.pop(context),
               onNext: () {},
               title: '',
             ),
           ),

         ],)),


          // ── Tax settings ──────────────────────────────
         Expanded(child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,

           children: [
           SectionTitle(title: 'Tax Settings'),
           const SizedBox(height: 4),
           const Text(
             'Set the tax percentage applied to all transactions.',
             style: TextStyle(fontSize: 12, color: Colors.grey),
           ),
           const SizedBox(height: 16),

           SizedBox(
             width: 600,
             child: TaxSettingsForm(),
           ),
         ],))


        ],
      ),
    );
  }
}

