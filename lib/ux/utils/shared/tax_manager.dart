import 'package:shared_preferences/shared_preferences.dart';

class TaxManager {
  // ── Singleton ─────────────────────────────────────────────
  static final TaxManager _instance = TaxManager._internal();
  factory TaxManager() => _instance;
  TaxManager._internal();

  // ── State ─────────────────────────────────────────────────
  bool _taxEnabled = false;
  double _taxRate = 0.0;
  String _taxName = 'VAT';

  // ── Keys ──────────────────────────────────────────────────
  static const _keyEnabled = 'tax_enabled';
  static const _keyRate    = 'tax_rate';
  static const _keyName    = 'tax_name';

  // ── Getters ───────────────────────────────────────────────
  bool   get taxEnabled => _taxEnabled;
  double get taxRate    => _taxRate;
  String get taxName    => _taxName;

  bool get hasTax => _taxEnabled && _taxRate > 0;

  // ── Load from SharedPreferences ───────────────────────────
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _taxEnabled = prefs.getBool(_keyEnabled)   ?? false;
    _taxRate    = prefs.getDouble(_keyRate)     ?? 0.0;
    _taxName    = prefs.getString(_keyName)     ?? 'VAT';
  }

  // ── Save to SharedPreferences ─────────────────────────────
  Future<void> save({
    required bool enabled,
    required double rate,
    required String name,
  }) async {
    _taxEnabled = enabled;
    _taxRate    = rate;
    _taxName    = name;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, enabled);
    await prefs.setDouble(_keyRate, rate);
    await prefs.setString(_keyName, name);
  }

  // ── Tax calculations ──────────────────────────────────────
  // calculate tax amount from subtotal
  double calculateTax(double subtotal) {
    if (!_taxEnabled || _taxRate <= 0) return 0.0;
    return subtotal * (_taxRate / 100);
  }

  // calculate total including tax
  double calculateTotal(double subtotal) {
    return subtotal + calculateTax(subtotal);
  }

  // calculate subtotal from a total that already includes tax
  double subtotalFromTotal(double total) {
    if (!_taxEnabled || _taxRate <= 0) return total;
    return total / (1 + (_taxRate / 100));
  }

  // ── Display helpers ───────────────────────────────────────
  // e.g. "VAT (15%)"
  String get taxLabel {
    if (!_taxEnabled || _taxRate <= 0) return 'No Tax';
    return '$_taxName (${_taxRate % 1 == 0 ? _taxRate.toInt() : _taxRate}%)';
  }

  // e.g. "15%"
  String get rateLabel {
    if (_taxRate % 1 == 0) return '${_taxRate.toInt()}%';
    return '$_taxRate%';
  }

  // formatted tax amount string
  String taxAmountDisplay(double subtotal, String symbol) {
    final tax = calculateTax(subtotal);
    return '$symbol ${tax.toStringAsFixed(2)}';
  }

  // ── Reset ─────────────────────────────────────────────────
  Future<void> reset() async {
    await save(enabled: false, rate: 0.0, name: 'VAT');
  }
}