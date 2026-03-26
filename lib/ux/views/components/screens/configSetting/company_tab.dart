// ─────────────────────────────────────────────────────────────
// ── COMPANY TAB ───────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
import 'package:eswaini_destop_app/ux/views/components/screens/configSetting/section_title.dart';
import 'package:flutter/cupertino.dart';

import '../../../../utils/shared/screen.dart';
import '../../shared/create_company.dart';

class CompanyTab extends StatefulWidget {
  const CompanyTab();

  @override
  State<CompanyTab> createState() => CompanyTabState();
}

class CompanyTabState extends State<CompanyTab> {


  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'Company Information'),
          SizedBox(
            width: 600,
            height: ScreenUtil.height * 0.5,
            child: CreateCompany(
                isSetUp: false,
                onCancel: (){Navigator.pop(context);},
                onNext: (){}, title: ''),
          )

        ],
      ),
    );
  }
}