import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../../Providers/transaction_provider.dart';
import '../../../models/shared/transaction.dart';
import '../../../utils/shared/app.dart';
import '../dialogs/add_and_edit_users.dart';
import '../dialogs/logout.dart';

class ExchangeRate extends StatefulWidget {
  final bool isProcessing;
  final bool isHomeScreen;
  const ExchangeRate({
    super.key,
    this.isHomeScreen = false,
    required this.isProcessing,
  });

  @override
  State<ExchangeRate> createState() => _ExchangeRateState();
}

class _ExchangeRateState extends State<ExchangeRate> {
  final ScrollController _scrollController = ScrollController();

  final sessionManager = SessionManager();
  bool isLoading = true;
  final transactionManager = TransactionManager();

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    transactionManager.loadTransactions(onFliter: () {}, isSubHeader: true);

    // Start scrolling after layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());

    // Refresh rates every 60 seconds
    // _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   _fetchExchangeRates();
    // });
  }

  @override
  void dispose() {

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



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.isProcessing) {
                AppUtil.toastMessage(
                  context: context,
                  message: AppStrings.processingPleaseWait,
                );
                return;
              }
              AppUtil.displayDialog(
                dismissible: false,
                context: context,
                child: LogoutDialog(),
              );
              // Add your logout logic here
            },
            child: _buildActionCard(
              icon: AppDrawables.lockSVG,
              label: AppStrings.lockApp,
              color: AppColors.secondaryColor,
            ),
          ),
          _buildDivider(),
          _buildCard(
          text: transactionManager.totalAmount.toStringAsFixed(2),
          image: AppDrawables.moneySVG,
          isShowCurrency: true,
          title:AppStrings.totalTransactions ,
          ),
          _buildDivider(),
          Expanded(child: _buildTransactionSummaryCard()),
          _buildDivider(),
          _buildCard(
            text: transactionManager.filtered.length.toString(),
            image: AppDrawables.moneySVG,
            isShowCurrency: false,
            title:AppStrings.totalCount ,
          ),
          _buildDivider(),
          widget.isHomeScreen
              ? (sessionManager.isCashier
                    ? InkWell(
                        onTap: () {
                          if (widget.isProcessing) {
                            AppUtil.toastMessage(
                              context: context,
                              message: AppStrings.processingPleaseWait,
                            );
                            return;
                          }
                          AppUtil.displayDialog(
                            dismissible: false,
                            context: context,
                            child: AddEditUsersDialog(
                              userName: sessionManager.userName,
                              userEmail: sessionManager.userEmail,
                              userPassword: sessionManager.userPassword,
                              selectedRole: sessionManager.userRole,
                            ),
                          );
                        },
                        child: _buildActionCard(
                          icon: AppDrawables.profileSVG,
                          label: AppStrings.profile,
                          color: AppColors.secondaryColor,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          if (widget.isProcessing) {
                            AppUtil.toastMessage(
                              context: context,
                              message: AppStrings.processingPleaseWait,
                            );
                            return;
                          }
                          AppNavigator.gotoConfigSettings(context: context);
                        },
                        child: _buildActionCard(
                          icon: AppDrawables.settingsSVG,
                          label: AppStrings.sysSettings,
                          color: AppColors.secondaryColor,
                        ),
                      ))
              : InkWell(
                  onTap: () {
                    if (widget.isProcessing) {
                      AppUtil.toastMessage(
                        context: context,
                        message: AppStrings.processingPleaseWait,
                      );
                      return;
                    }
                    AppNavigator.gotoHome(TransactionData(), context: context);
                  },
                  child: _buildActionCard(
                    icon: AppDrawables.homeSVG,
                    label: AppStrings.toHomeScreen,
                    color: AppColors.secondaryColor,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTransactionSummaryCard() {
    return _InfoCard(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 8),
          SvgPicture.asset(AppDrawables.rateSVG, height: 16),
          const SizedBox(width: 8),
          Text(
            AppStrings.transactionSummary,
            style: AppTheme.getTextStyle(bold: true, size: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildSummayText(
                    text: transactionManager.refundedCount.toString(),
                    title:AppStrings.refunded ,
                  ),
                      _buildDivider(),
                      _buildSummayText(
                    text: transactionManager.voidedCount.toString(),

                    title:AppStrings.voidTransactions ,
                  ),
                      _buildDivider(),
                      _buildSummayText(
                    text: transactionManager.cashCount.toString(),
                    title:AppStrings.cash ,
                  ),
                      _buildDivider(),
                      _buildSummayText(
                        text: transactionManager.mobileCount.toString(),
                        title:AppStrings.mobile ,
                      ),
                      _buildDivider(),
                      _buildSummayText(
                        text: transactionManager.cardCount.toString(),
                        title:AppStrings.card ,
                      ),
                      _buildDivider(),
                      _buildSummayText(
                        text: transactionManager.splitCount.toString(),
                        title:AppStrings.split ,
                      ),
                     // Duplicated for seamless looping
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String label,
    required Color color,
  }) {
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
  Widget _buildSummayText({
    required String title,
    required String text,
  }) {
    return  Padding(padding: EdgeInsets.symmetric(horizontal: 8),child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [


        Text(title, style: AppTheme.getTextStyle(bold: true, size: 12)),
        const SizedBox(width: 6),
        Text(
          ' $text',
          style: AppTheme.getTextStyle(size: 12),
        ),
      ],

    ),);
  }
  Widget _buildCard({
    required String title,
    required String text,
    required String image,
    required bool isShowCurrency,
  }) {
    return _InfoCard(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(image, height: 16),
          const SizedBox(width: 6),
          Text(title, style: AppTheme.getTextStyle(bold: true, size: 12)),
          Text(
            isShowCurrency?' ${ConstantUtil.currencySymbol} $text':' $text',
            style: AppTheme.getTextStyle(size: 12),
          ),
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
          height: ScreenUtil.height * 0.05,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSecondary
                ? AppColors.secondaryColor.withValues(
                    alpha: isHovered ? 1.0 : 0.1,
                  )
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
