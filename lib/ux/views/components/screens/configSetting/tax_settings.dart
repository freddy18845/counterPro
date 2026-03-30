// ─────────────────────────────────────────────────────────────
// ── TAX SETTINGS FORM ─────────────────────────────────────────
// ─────────────────────────────────────────────────────────────
import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../res/app_colors.dart';
import '../../../../utils/shared/app.dart';
import '../../shared/btn.dart';
import '../../shared/login_input.dart';

class TaxSettingsForm extends StatefulWidget {
  @override
  State<TaxSettingsForm> createState() => TaxSettingsFormState();
}

class TaxSettingsFormState extends State<TaxSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _taxController = TextEditingController();
  final _taxNameController = TextEditingController();

  bool _taxEnabled = false;
  bool _isLoading = false;
  bool _isSaving = false;

  // prefs keys
  static const _keyTaxEnabled = 'tax_enabled';
  static const _keyTaxRate = 'tax_rate';
  static const _keyTaxName = 'tax_name';

  @override
  void initState() {
    super.initState();
    _loadTaxSettings();
  }

  Future<void> _loadTaxSettings() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _taxEnabled = prefs.getBool(_keyTaxEnabled) ?? true;
      _taxController.text =
          (prefs.getDouble(_keyTaxRate) ?? 0.0)
              .toStringAsFixed(2);
      _taxNameController.text =
          prefs.getString(_keyTaxName) ?? 'VAT';
      _isLoading = false;
    });
  }

  Future<void> _saveTaxSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final rate =
        double.tryParse(_taxController.text.trim()) ?? 0.0;

    await prefs.setBool(_keyTaxEnabled, _taxEnabled);
    await prefs.setDouble(_keyTaxRate, rate);
    await prefs.setString(
        _keyTaxName, _taxNameController.text.trim());

    setState(() => _isSaving = false);

    if (mounted) {
      AppUtil.toastMessage(
        message: '✅ Tax settings saved',
        context: context,
        backgroundColor: Colors.green,
      );
    }
  }

  @override
  void dispose() {
    _taxController.dispose();
    _taxNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Enable/disable tax ────────────────────
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enable Tax',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _taxEnabled
                          ? 'Tax is applied to all transactions'
                          : 'No tax on transactions',
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() => _taxEnabled = !_taxEnabled),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _taxEnabled
                          ? AppColors.primaryColor
                          : Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AnimatedAlign(
                      duration:
                      const Duration(milliseconds: 200),
                      alignment: _taxEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Tax fields ────────────────────────────
            AnimatedOpacity(
              opacity: _taxEnabled ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 200),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // tax name
                      Expanded(
                        child: InputField(
                          label: 'Tax Name',
                          controller: _taxNameController,
                          hintText: 'e.g. VAT, GST, Tax',
                          prexIcon: Icons.label_outline,
                          enabled: _taxEnabled,
                          validator: (v) {
                            if (!_taxEnabled) return null;
                            if (v == null || v.isEmpty) {
                              return 'Tax name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // tax rate
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            InputField(
                              label: 'Tax Rate (%)',
                              controller: _taxController,
                              hintText: '0.00',
                              prexIcon:
                              Icons.percent_outlined,
                              enabled: _taxEnabled,
                              keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                                  decimal: true),
                              validator: (v) {
                                if (!_taxEnabled) return null;
                                if (v == null || v.isEmpty) {
                                  return 'Tax rate is required';
                                }
                                final rate =
                                double.tryParse(v);
                                if (rate == null) {
                                  return 'Enter a valid number';
                                }
                                if (rate < 0 || rate > 100) {
                                  return 'Must be between 0 and 100';
                                }
                                return null;
                              },
                            ),

                            // preview
                            if (_taxEnabled) ...[
                              const SizedBox(height: 6),
                              Builder(builder: (context) {
                                final rate = double.tryParse(
                                    _taxController.text) ??
                                    0.0;
                                final example =
                                (100 * rate / 100)
                                    .toStringAsFixed(2);
                                return Text(
                                  'e.g. On ${ConstantUtil.currencySymbol}100.00 → tax = ${ConstantUtil.currencySymbol}$example',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors
                                        .primaryColor,
                                  ),
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // quick presets
                  if (_taxEnabled) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick presets:',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [0, 5, 10, 12.5, 15, 20]
                          .map((rate) {
                        final label = rate ==
                            rate.toInt()
                            ? '${rate.toInt()}%'
                            : '$rate%';
                        final isSelected =
                            _taxController.text ==
                                rate.toStringAsFixed(2);

                        return GestureDetector(
                          onTap: () => setState(() {
                            _taxController.text =
                                rate.toStringAsFixed(2);
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 150),
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey
                                  .withValues(alpha: 0.08),
                              borderRadius:
                              BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey.withValues(
                                    alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── info banner ───────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                Colors.amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.amber
                        .withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 14, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tax changes apply to new transactions only. '
                          'Existing transactions are not affected.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── save button ───────────────────────────
            SizedBox(
              width: 160,
              child: ColorBtn(
                text:
                _isSaving ? 'Saving...' : 'Save Tax Settings',
                btnColor: AppColors.secondaryColor,
                action: _isSaving ? (){} : _saveTaxSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}