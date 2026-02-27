// import "package:flutter/foundation.dart";
// import "package:rise_app/ux/res/app_colors.dart";
// import "package:rise_app/ux/res/app_drawables.dart";
// import "package:rise_app/ux/res/app_strings.dart";
// import "package:rise_app/ux/res/app_theme.dart";
// import "package:rise_app/ux/utils/shared/screen.dart";
// import "package:rise_app/ux/views/components/shared/app_bar_button.dart";
// import "package:rise_app/ux/views/components/shared/base_layout.dart";
// import "package:rise_app/ux/views/components/shared/control_btn.dart";
// import "package:rise_app/ux/views/components/shared/custom_app_bar.dart";
// import "package:flutter/material.dart";
// import "../../../platform/utils/config_setup.dart";
// import "../../../platform/utils/constant.dart";
// import "../../Providers/device_provider.dart";
// import "../../utils/shared/app.dart";
//
// class ConfigSettingsScreen extends StatefulWidget {
//   const ConfigSettingsScreen({super.key});
//
//   @override
//   State<ConfigSettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<ConfigSettingsScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _ipController = TextEditingController();
//   final _acquirerIdController = TextEditingController();
//   final _terminalCapabilitiesController = TextEditingController();
//   final _additionalTerminalCapabilitiesController = TextEditingController();
//
//   bool _debugModeEnabled = false;
//   String? _deviceData;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDeviceData();
//     _loadSavedConfig();
//   }
//
//   @override
//   void dispose() {
//     _ipController.dispose();
//     _acquirerIdController.dispose();
//     _terminalCapabilitiesController.dispose();
//     _additionalTerminalCapabilitiesController.dispose();
//     super.dispose();
//   }
//
//   /// ✅ Load config safely
//   Future<void> _loadSavedConfig() async {
//     try {
//       final config = await DebugConfigStorage.retrieveAppDebugConfig();
//
//       setState(() {
//         _debugModeEnabled = config[DebugKeys.debugModeEnabled] ?? false;
//         _ipController.text = config[DebugKeys.baseUrl] ?? '';
//         _acquirerIdController.text = config[DebugKeys.acquirerId] ?? '';
//         _terminalCapabilitiesController.text =
//             config[DebugKeys.terminalCapabilities] ?? '';
//         _additionalTerminalCapabilitiesController.text =
//             config[DebugKeys.additionalTerminalCapabilities] ?? '';
//       });
//
//       if ((_ipController.text).isNotEmpty) {
//         ConstantUtil.defaultUrl = _ipController.text;
//       }
//     } catch (e) {
//       if (kDebugMode) print('❌ Error loading saved config: $e');
//     }
//   }
//
//   Future<void> _loadDeviceData() async {
//     try {
//       final deviceInfo = DeviceManager().getDeviceData();
//       final deviceData = await deviceInfo.deviceId;
//       setState(() => _deviceData = deviceData);
//     } catch (e) {
//       if (kDebugMode) print('❌ Error loading device data: $e');
//     }
//   }
//
//   /// ✅ Update config safely
//   Future<void> _updateConfig(BuildContext context) async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;
//
//     String baseUrl = _ipController.text.trim();
//     if (baseUrl.isNotEmpty &&
//         !baseUrl.startsWith("http://") &&
//         !baseUrl.startsWith("https://")) {
//       baseUrl = "http://$baseUrl";
//     }
//
//     final success = await DebugConfigStorage.storeAppConfig(
//       baseUrl: baseUrl.isNotEmpty ? baseUrl : null,
//       acquirerId: _acquirerIdController.text.trim().isNotEmpty
//           ? _acquirerIdController.text.trim()
//           : null,
//       terminalCapabilities:
//           _terminalCapabilitiesController.text.trim().isNotEmpty
//               ? _terminalCapabilitiesController.text.trim()
//               : null,
//       additionalTerminalCapabilities:
//           _additionalTerminalCapabilitiesController.text.trim().isNotEmpty
//               ? _additionalTerminalCapabilitiesController.text.trim()
//               : null,
//       debugModeEnabled: _debugModeEnabled,
//     );
//
//     if (success) {
//       if (baseUrl.isNotEmpty) ConstantUtil.defaultUrl = baseUrl;
//       AppUtil.toastMessage(message: "✅ Configuration saved successfully!");
//     } else {
//       AppUtil.toastMessage(
//           message: "❌ Failed to save configuration. Please try again.");
//     }
//   }
//
//   Widget _buildFieldWithLabel(
//     String label,
//     TextEditingController controller,
//     String hintText, {
//     String? Function(String?)? validator,
//     bool enabled = true,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 14)),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           enabled: enabled,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             border: const OutlineInputBorder(),
//             isDense: true,
//           ),
//           validator: validator,
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       child: BaseLayout(
//         header: CustomAppBar(
//           isImage: false,
//           title: AppStrings.settings,
//           iconPath: AppDrawables.svgSettings,
//           leftActions: [
//             AppBarButton(
//               iconColor: AppColors.primaryColor,
//               iconPath: AppDrawables.svgBackBlack,
//               callback: () => Navigator.pop(context),
//             ),
//           ],
//           rightActions: const [],
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
// // ✅ Header with debug toggle
//             Container(
//               width: double.infinity,
//               height: ScreenUtil.height * 0.15,
//               padding: EdgeInsets.symmetric(
//                 horizontal: ScreenUtil.width * 0.03,
//                 vertical: ScreenUtil.height * 0.025,
//               ),
//               decoration: BoxDecoration(gradient: AppTheme.gradientBg),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(AppStrings.debugMode_,
//                           style:
//                               AppTheme.textStyle.copyWith(color: Colors.white)),
//                       Checkbox(
//                         value: _debugModeEnabled,
//                         onChanged: (value) async {
//                           final newValue = value ?? false;
//                           setState(() => _debugModeEnabled = newValue);
//
//                           if (!newValue) {
//                             await DebugConfigStorage.storeAppConfig(
//                               debugModeEnabled: false,
//                             );
//                             if (kDebugMode) print('🔕 Debug mode disabled');
//                           }
//                         },
//                         side: const BorderSide(
//                             color: AppColors.primaryColor, width: 1.5),
//                         checkColor: Colors.white,
//                         activeColor: AppColors.primaryColor,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("${AppStrings.deviceId_}",
//                           style:
//                               AppTheme.textStyle.copyWith(color: Colors.white)),
//                       Text(" ${_deviceData ?? 'Unknown'}",
//                           style:
//                               AppTheme.textStyle.copyWith(color: Colors.white)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
// // ✅ Input fields
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.all(ScreenUtil.width * 0.03),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       _buildFieldWithLabel(
//                         "API Endpoint",
//                         _ipController,
//                         'http://172.60.254.158:9090/',
//                         validator: (value) {
//                           if (value == null || value.isEmpty) return null;
//                           final regex = RegExp(
//                             r'^(http://|https://)((\d{1,3}\.){3}\d{1,3})(:\d{1,5})?(/\S*)?$',
//                           );
//                           if (!regex.hasMatch(value)) {
//                             return 'Invalid format. Example: http://172.60.254.158:9090/';
//                           }
//                           return null;
//                         },
//                         enabled: _debugModeEnabled,
//                       ),
//                       _buildFieldWithLabel(
//                           "Acquirer ID", _acquirerIdController, "770000",
//                           enabled: _debugModeEnabled),
//                       _buildFieldWithLabel(
//                         "Terminal Capabilities",
//                         _terminalCapabilitiesController,
//                         "E06800",
//                         enabled: _debugModeEnabled,
//                       ),
//                       _buildFieldWithLabel(
//                         "Additional Terminal Capabilities",
//                         _additionalTerminalCapabilitiesController,
//                         "FF80D0F001",
//                         enabled: _debugModeEnabled,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
// // ✅ Bottom buttons
//             Padding(
//               padding: EdgeInsets.all(ScreenUtil.width * 0.03),
//               child: ControlButton(
//                 text: AppStrings.saveChanges,
//                 onPressed: () => _updateConfig(context),
//                 onCancel: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
