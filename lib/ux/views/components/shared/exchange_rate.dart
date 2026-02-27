import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class ExchangeRate extends StatefulWidget {
final bool  isHomeScreen;
  const ExchangeRate({super.key,  this.isHomeScreen =false});

  @override
  State<ExchangeRate> createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  final ScrollController _scrollController = ScrollController();

  Map<String, double> exchangeRates = {
    'USD': 0.055, 'EUR': 0.051, 'XAF': 33.5, 'JPY': 8.2, 'GBP': 0.043,
  };
  Map<String, double> previousRates = {};

  bool isLoading = true;
  bool _isHovering = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();

    // Start scrolling after layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());

    // Refresh rates every 60 seconds
    // _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   _fetchExchangeRates();
    // });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() async {
    while (mounted) {
      // Pause animation if the user is hovering with mouse
      if (_scrollController.hasClients && !_isHovering) {
        final double maxScroll = _scrollController.position.maxScrollExtent;
        final double currentScroll = _scrollController.position.pixels;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1,
            duration: const Duration(milliseconds: 30),
            curve: Curves.linear,
          );
        }
      }
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  Future<void> _fetchExchangeRates() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/SZL'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        if (mounted) {
          setState(() {
            previousRates = Map.from(exchangeRates);
            exchangeRates = {
              'USD': rates['USD']?.toDouble() ?? 0.0,
              'EUR': rates['EUR']?.toDouble() ?? 0.0,
              'XAF': rates['XAF']?.toDouble() ?? 0.0,
              'JPY': rates['JPY']?.toDouble() ?? 0.0,
              'GBP': rates['GBP']?.toDouble() ?? 0.0,
            };
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching exchange rates: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  String _getRateChange(String currency) {
    if (previousRates.isEmpty) return "+0.00";
    final current = exchangeRates[currency] ?? 0.0;
    final previous = previousRates[currency] ?? 0.0;
    if (previous == 0) return "+0.00";

    final change = ((current - previous) / previous) * 100;
    return (change >= 0 ? "+" : "") + change.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing),
      child: Row(
        children: [
          _buildActionCard(
            icon: AppDrawables.lockSVG,
            label: AppStrings.lockApp,
            color: AppColors.secondaryColor,
          ),
          _buildDivider(),
          _buildFloatBalanceCard(),
          _buildDivider(),
          Expanded(child: _buildExchangeRatesCard()),
          _buildDivider(),
         widget.isHomeScreen? _buildActionCard(
            icon: AppDrawables.settingsSVG,
            label: AppStrings.sysSettings,
            color: AppColors.secondaryColor,
          ):InkWell(onTap: (){
            AppNavigator.gotoHome(context: context);
         },
         child: _buildActionCard(
           icon: AppDrawables.homeSVG,
           label: AppStrings.toHomeScreen,
           color: AppColors.secondaryColor,
         ),)
        ],
      ),
    );
  }

  Widget _buildExchangeRatesCard() {
    return _InfoCard(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 8),
          SvgPicture.asset(AppDrawables.rateSVG, height: 16),
          const SizedBox(width: 8),
          Text(
            AppStrings.exchangeRates,
            style: AppTheme.getTextStyle(bold: true, size: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      ..._buildRateGroup(),
                      ..._buildRateGroup(), // Duplicated for seamless looping
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildRateGroup() {
    return exchangeRates.keys.map((currency) {
      return _buildRateItem(currency, exchangeRates[currency]!);
    }).toList()..add(const SizedBox(width: 40));
  }

  Widget _buildRateItem(String currency, double rate) {
    final changeText = _getRateChange(currency);
    final isPositive = !changeText.contains('-');

    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$currency ', style: AppTheme.getTextStyle(size: 12)),
          Text(
            changeText,
            style: AppTheme.getTextStyle(
              size: 12,
              color:  Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            isPositive ? AppDrawables.arrowUpSVG : AppDrawables.arrowDownSVG,
            height: 10,
            colorFilter: ColorFilter.mode(
              isPositive ? Colors.green : Colors.red,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required String icon, required String label, required Color color}) {
    return _InfoCard(
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, height: 16),
          const SizedBox(width: 6),
          Container(width: 1, height: 17, color: Colors.grey.withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.getTextStyle(bold: true, size: 12)),
        ],
      ),
    );
  }

  Widget _buildFloatBalanceCard() {
    return _InfoCard(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppDrawables.moneySVG, height: 16),
          const SizedBox(width: 6),
          Text("${AppStrings.floatBalance} ", style: AppTheme.getTextStyle(bold: true, size: 12)),
          Text('SZL 629,039,045', style: AppTheme.getTextStyle(size: 12)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
    height: 25,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: const VerticalDivider(thickness: 1, color: Colors.grey),
  );
}

class _InfoCard extends StatefulWidget {
  final Color color;
  final Widget child;
  const _InfoCard({required this.color, required this.child});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isSecondary = widget.color == AppColors.secondaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSecondary
                ? AppColors.secondaryColor.withValues(alpha: isHovered ? 1.0 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: isSecondary
                  ? AppColors.secondaryColor
                  : Colors.grey.shade300,
            ),
            boxShadow: isHovered
                ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}