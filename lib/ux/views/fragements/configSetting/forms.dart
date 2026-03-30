import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../components/screens/configSetting/section_title.dart';
import '../../components/shared/btn.dart';
import '../../components/shared/login_input.dart';

class Forms extends StatefulWidget {
  final TextEditingController apiKeyController;
  final TextEditingController baseUrlController;
  final bool isValidating;
  final bool isSaving;
  final Function() validateApiKey;
  final Function() saveSettings;
  const Forms({super.key, required this.apiKeyController, required this.baseUrlController, required this.isValidating, required this.isSaving, required this.validateApiKey, required this.saveSettings});

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: 'API Settings'),
          const SizedBox(height: 12),
          InputField(
            label: 'API Key',
            controller:widget.apiKeyController,
            hintText: 'Enter your CounterPro API key',
            prexIcon: Icons.key_outlined,
            obscureText: true,
            showVisibilityToggle: true,
            enabled: true,
            validator: (v) => v == null || v.isEmpty
                ? 'API key is required'
                : null,
          ),

          const SizedBox(height: 12),
          InputField(
            label: 'Server URL',
            controller: widget.baseUrlController,
            hintText: 'Enter Your Dedicated Url',
            prexIcon: Icons.link_outlined,
            enabled: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Server URL is required';
              if (!v.startsWith('http')) return 'URL must start with http or https';
              return null;
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ColorBtn(
                  text:  widget.isValidating
                      ? 'Validating...'
                      : 'Test Connection',
                  btnColor: AppColors.primaryColor,
                  action:  widget.isValidating ? () {} : (){
                    widget.validateApiKey();
                  }
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ColorBtn(
                  text:  widget.isSaving ? 'Saving...' : 'Save Settings',
                  btnColor: AppColors.secondaryColor,
                  action:  widget.isSaving ? () {} :(){
                    widget.saveSettings();
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
