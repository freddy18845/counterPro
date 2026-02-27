
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../blocs/screens/splash/bloc.dart";
import "../../res/app_drawables.dart";
import "../../res/app_strings.dart";
import "../../utils/shared/screen.dart";


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashBloc splashBloc;

  @override
  void initState() {
    splashBloc = context.read<SplashBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashBloc.add(SplashInitEvent(context: context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, SplashState state) {
        return PopScope(
          canPop: state is SplashErrorState,
          child: Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppDrawables.loadingScreen),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Center(
                    child: SvgPicture.asset(
                      AppDrawables.logoSVG,
                      width: 150,
                      height: 70,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.1),
                  CupertinoActivityIndicator(radius: 18, color: Colors.white),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Text(
                      AppStrings.link,
                      style: TextStyle(
                        fontSize: (ScreenUtil.height * 0.02).clamp(8, 10),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
