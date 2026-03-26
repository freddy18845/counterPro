
import "package:flutter/material.dart";
import "../../../platform/utils/constant.dart";
import "../../../platform/utils/isar_manager.dart";
import "../../res/app_colors.dart";
import "../../res/app_strings.dart";
import "../components/screens/configSetting/company_tab.dart";
import "../components/screens/configSetting/import_export_tab.dart";
import "../components/screens/configSetting/subscription_tab.dart";
import "../components/screens/configSetting/user_tap.dart";
import "../components/shared/card_widget.dart";
import "../components/shared/inline_text.dart";
import "../components/shared/ui_template.dart";

// ── Config tab enum ───────────────────────────────────────────
enum ConfigTab { company, users, subscription, importExport }

class SystemConfigScreen extends StatefulWidget {



  const SystemConfigScreen({
    super.key,

  });

  @override
  State<SystemConfigScreen> createState() => _SystemConfigScreenState();
}

class _SystemConfigScreenState extends State<SystemConfigScreen> {

  final isar = IsarService.db;
  ConfigTab _activeTab = ConfigTab.company;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _tabLabel(ConfigTab t) => switch (t) {
    ConfigTab.company => 'Company',
    ConfigTab.users => 'Users',
    ConfigTab.subscription => 'Subscription',
    ConfigTab.importExport => 'Import / Export',
  };

  IconData _tabIcon(ConfigTab t) => switch (t) {
    ConfigTab.company => Icons.business_outlined,
    ConfigTab.users => Icons.people_outlined,
    ConfigTab.subscription => Icons.workspace_premium_outlined,
    ConfigTab.importExport => Icons.import_export_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      contentSection: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ConstantUtil.verticalSpacing / 2),
            InlineText(
              title: AppStrings.sysSettings.toUpperCase(),
            ),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Tab bar ───────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ConfigTab.values.map((tab) {
                  final isActive = _activeTab == tab;
                  return GestureDetector(
                    onTap: () => setState(() => _activeTab = tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primaryColor
                              : Colors.grey.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _tabIcon(tab),
                            size: 14,
                            color: isActive
                                ? Colors.white
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _tabLabel(tab),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: ConstantUtil.verticalSpacing / 4),
            Divider(
                thickness: 1.5, color: AppColors.secondaryColor),
            SizedBox(height: ConstantUtil.verticalSpacing / 4),

            // ── Tab content ───────────────────────────────
            Expanded(
              child: switch (_activeTab) {
                ConfigTab.company => CompanyTab(),
                ConfigTab.users => UsersTab(isar: isar),
                ConfigTab.subscription => const SubscriptionTab(),
                ConfigTab.importExport =>
                    ImportExportTab(isar: isar),
              },
            ),
          ],
        ),
      ),
    );
  }
}







