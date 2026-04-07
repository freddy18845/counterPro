import 'dart:ui';
import 'package:eswaini_destop_app/ux/nav/app_navigator.dart';
import 'package:eswaini_destop_app/ux/utils/shared/app.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/add_user.dart';
import 'package:flutter/material.dart';
import 'package:eswaini_destop_app/ux/utils/shared/screen.dart';
import 'package:eswaini_destop_app/ux/views/components/shared/create_company.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import '../../res/app_colors.dart';
import '../../res/app_drawables.dart';
import '../components/shared/footer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _previousPage() async {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return;
    }
    final isar = Isar.getInstance();
    await isar?.writeTxn(() async {
      await isar.clear();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);

    final screenWidth = ScreenUtil.width;
    final screenHeight = ScreenUtil.height;
    final cardWidth = (screenWidth * 0.55).clamp(320.0, _currentPage == 0?600.0:500);
    final cardHeight = (screenHeight * 0.85).clamp(400.0, _currentPage == 0?680.0:500);

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: supportInfo(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppDrawables.loadingScreen),
              fit: BoxFit.fill,
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.1),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      // logo


                      Container(
                        width: cardWidth.toDouble(),
                        height: cardHeight.toDouble(),
                        margin: EdgeInsets.only(
                          bottom: screenHeight * 0.05,
                          top: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardOutlineColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 3),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                        Center(
                        child:RepaintBoundary(
                        child: SvgPicture.asset(
                        AppDrawables.darkLogoSVG,
                          width: 100,
                          height: 50,
                          fit: BoxFit.fitWidth,
                        ),)),
                            SizedBox(height: 4,),
                            // ── Page indicator top label ──────────

                            Divider(thickness: 1, color: Colors.grey),
                            // ── PageView ──────────────────────────
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                children: [
                                  // Page 1 — Company info
                                  CreateCompany(
                                    title:  _currentPage == 0
                                        ? 'Step 1 — Company Details'
                                        : 'Step 2 — Admin Account',
                                    onCancel: _previousPage,
                                    onNext: _nextPage,
                                    isSetUp: true,
                                  ),

                                  // Page 2 — Admin user
                                  AddUser(
                                    isSetUp: true,
                                    onCancel: _previousPage,
                                    onNext: () {
                                      AppUtil.toastMessage(
                                        message: "Company Creation Successful",
                                        context: context,
                                      );
                                      AppNavigator.gotoLogin(context: context,isFromSetUp: true);
                                    },
                                    // final submit on last page
                                  ),
                                ],
                              ),
                            ),

                            // ── Dot indicator ─────────────────────
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _totalPages,
                                      (index) => RepaintBoundary(
                                        child:AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    width: _currentPage == index ? 24 : 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? AppColors.secondaryColor
                                          : Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                        )  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ] ,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
