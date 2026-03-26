import 'dart:async';
import 'dart:ui';

import 'package:eswaini_destop_app/ux/views/components/shared/stock_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:eswaini_destop_app/platform/utils/constant.dart';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/res/app_colors.dart';
import 'package:eswaini_destop_app/ux/res/app_drawables.dart';
import 'package:eswaini_destop_app/ux/res/app_strings.dart';
import 'package:eswaini_destop_app/ux/res/app_theme.dart';
import 'package:eswaini_destop_app/ux/utils/sessionManager.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';

import '../../../Providers/transaction_provider.dart';
import '../../../models/shared/transaction.dart';
import '../../../utils/shared/app.dart';
import '../dialogs/add_and_edit_users.dart';
import '../dialogs/logout.dart';

class SummaryData extends StatefulWidget {
  final bool isProcessing;
  final bool isHomeScreen;

  const SummaryData({
    super.key,
    this.isHomeScreen = false,
    required this.isProcessing,
  });

  @override
  State<SummaryData> createState() => _SummaryDataState();
}

class _SummaryDataState extends State<SummaryData> {
  final ScrollController _scrollController = ScrollController();
  final sessionManager = SessionManager();
  final transactionManager = TransactionManager();


  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    transactionManager.loadTransactions(onFliter: () {}, isSubHeader: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // =========================
  // ACTION HANDLER
  // =========================
  void _handleAction(VoidCallback action) {
    if (widget.isProcessing) {
      AppUtil.toastMessage(
        context: context,
        message: AppStrings.processingPleaseWait,
      );
      return;
    }
    action();
  }

  Widget _actionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () => _handleAction(onTap),
      child: _buildActionCard(
        icon: icon,
        label: label,
        color: AppColors.secondaryColor,
      ),
    );
  }

  // =========================
  // LEFT ACTION
  // =========================
  Widget _buildLeftAction(bool isDesktop) {
    if (widget.isHomeScreen) {
      return sessionManager.isCashier
          ? _actionButton(
              icon: AppDrawables.profileSVG,
              label: AppStrings.profile,
              onTap: () => AppUtil.displayDialog(
                dismissible: false,
                context: context,
                child: AddEditUsersDialog(
                  user: sessionManager.currentUser,
                ),
              ),
            )
          : _actionButton(
              icon: AppDrawables.settingsSVG,
              label: AppStrings.sysSettings,
              onTap: () => AppNavigator.gotoConfigSettings(context: context),
            );
    }

    return _actionButton(
      icon: AppDrawables.homeSVG,
      label: AppStrings.toHomeScreen,
      onTap: () => AppNavigator.gotoHome(TransactionData(), context: context),
    );
  }

  // =========================
  // RIGHT ACTION
  // =========================
  Widget _buildRightAction(bool isDesktop) {
    return _actionButton(
      icon: AppDrawables.lockSVG,
      label: !isDesktop ? AppStrings.logout : AppStrings.lockApp,
      onTap: () => AppUtil.displayDialog(
        dismissible: false,
        context: context,
        child: LogoutDialog(),
      ),
    );
  }

  // =========================
  // AUTO SCROLL
  // =========================
  void _startScrolling() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_scrollController.hasClients && !_isHovering) {
        final max = _scrollController.position.maxScrollExtent;
        final current = _scrollController.offset;

        final next = current + 2;

        _scrollController.jumpTo(next >= max ? 0 : next);
      }
    });
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ScreenUtil.width >= 900;

    return Padding(
      padding: EdgeInsets.only(bottom: ConstantUtil.verticalSpacing),
      child: Row(
        children: [
          _buildLeftAction(isDesktop),
          _buildDivider(isSummary: false),

      InkWell(
        onTap: () {
          AppNavigator.gotoTransaction(
            context: context,
            data: ConstantUtil.options[3],
          );
        },
        child: _buildCard(
            text: transactionManager.totalAmount.toStringAsFixed(2),
            image: AppDrawables.moneySVG,
            isShowCurrency: true,
            title:isDesktop?AppStrings.totalTransactions: "${AppStrings.total}:",
          ),),

          _buildDivider(isSummary: false),

          Expanded(
            child: InkWell(
              onTap: () {
                AppNavigator.gotoReports(
                  context: context,
                  data: ConstantUtil.options[4],
                );
              },
              child: _buildTransactionSummaryCard(isDesktop: isDesktop),
            ),
          ),

          _buildDivider(isSummary: false),

      InkWell(
        onTap: () {
          AppNavigator.gotoTransaction(
            context: context,
            data: ConstantUtil.options[3],
          );
        },child:    _buildCard(
            text: transactionManager.filtered.length.toString(),
            image: AppDrawables.moneySVG,
            isShowCurrency: false,
            title: isDesktop ? AppStrings.totalCount : AppStrings.count,
          ),),

          _buildDivider(isSummary: false),
          StockIcon(),
          _buildDivider(isSummary: false),
          _buildRightAction(isDesktop),
        ],
      ),
    );
  }

  // =========================
  // SUMMARY SCROLLER
  // =========================
  Widget _buildTransactionSummaryCard({required bool isDesktop}) {
    return _InfoCard(
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 8),
          SvgPicture.asset(AppDrawables.rateSVG, height: 16),
          const SizedBox(width: 8),

          if (isDesktop)
            Text(
              AppStrings.transactionSummary,
              style: AppTheme.getTextStyle(bold: true, size: 12),
            ),

          if (isDesktop) const SizedBox(width: 12),

          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _summaryItem(
                      isDesktop?AppStrings.refundedTransaction: AppStrings.refunded,
                      transactionManager.refundedCount,
                      isDesktop,
                    ),
                    _buildDivider(isSummary: true),
                    _summaryItem(
                      isDesktop?AppStrings.voidTransactions: AppStrings.voidText,
                      transactionManager.voidedCount,
                      isDesktop,
                    ),
                    _buildDivider(isSummary: true),
                    _summaryItem(
                      isDesktop?AppStrings.cashTransaction:  AppStrings.cash,
                      transactionManager.cashCount,
                      isDesktop,
                    ),
                    _buildDivider(isSummary: true),
                    _summaryItem(
                      isDesktop?AppStrings.mobileTransactions:AppStrings.mobile,
                      transactionManager.mobileCount,
                      isDesktop,
                    ),
                    _buildDivider(isSummary: true),
                    _summaryItem(
                      isDesktop?AppStrings.cardTransactions: AppStrings.card,
                      transactionManager.cardCount,
                      isDesktop,
                    ),
                    _buildDivider(isSummary: true),
                    _summaryItem(
                      AppStrings.split,
                      transactionManager.splitCount,
                      isDesktop,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, int value, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text(
            isDesktop ? title : title,
            style: AppTheme.getTextStyle(bold: true, size: 12),
          ),
          const SizedBox(width: 6),
          Text(
            " $value",
            style: AppTheme.getTextStyle(
              size: 15,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI HELPERS
  // =========================
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
          Container(width: 1, height: 17, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.getTextStyle(bold: true, size: 12)),
        ],
      ),
    );
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
        children: [
          SvgPicture.asset(image, height: 16),
          const SizedBox(width: 6),
          Text(title, style: AppTheme.getTextStyle(bold: true, size: 12)),
          Text(
            isShowCurrency ? ' ${ConstantUtil.currencySymbol} $text' : ' $text',
            style: AppTheme.getTextStyle(size: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({required bool isSummary}) => Container(
    height: isSummary ? 15 : 25,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: const VerticalDivider(thickness: 1),
  );
}

// =========================
// INFO CARD
// =========================
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
    final isSecondary = widget.color == AppColors.secondaryColor;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: ScreenUtil.height * 0.05,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSecondary
                ? AppColors.secondaryColor.withValues(
                    alpha: isHovered ? 1 : 0.1,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSecondary
                  ? AppColors.secondaryColor
                  : Colors.grey.shade300,
            ),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
