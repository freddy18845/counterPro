
import "package:flutter_svg/flutter_svg.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../../../platform/utils/cached_image.dart";
import "../../blocs/screens/splash/bloc.dart";
import "../../res/app_drawables.dart";
import "../../res/app_strings.dart";
import "../../utils/shared/screen.dart";
import "../components/shared/footer.dart";


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashBloc splashBloc;
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState(); // ✅ Always first
    splashBloc = context.read<SplashBloc>();

    // ✅ Delay the event until after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashBloc.add(SplashInitEvent(context: context));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesLoaded) {
      _imagesLoaded = true; // ✅ Prevent repeated calls
      loadImages();
    }
  }

  Future<void> loadImages() async {
    await precacheAppImages(context);
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context: context);
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, SplashState state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              bottomNavigationBar: supportInfo(),body: Container(
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
                    child:RepaintBoundary(
                      child: SvgPicture.asset(
                      AppDrawables.logoSVG,
                      width: 150,
                      height: 70,
                      fit: BoxFit.fitWidth,
                      )),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.1),
                  CupertinoActivityIndicator(radius: 18, color: Colors.white),
                  Spacer(),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


