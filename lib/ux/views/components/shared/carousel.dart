// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:slice/res/app_drawables.dart';
//
//
// class Carousel extends StatefulWidget {
//   const Carousel({super.key});
//
//   @override
//   State<Carousel> createState() => _CarouselState();
// }
//
// class _CarouselState extends State<Carousel> {
//   int _currentIndex = 0;
//   List<String> images = [
//     AppDrawables.slashImageOne,
//     AppDrawables.slashImageTwo,
//     AppDrawables.slashImageThee,
//     AppDrawables.slashImageFour
//   ];
//   Timer _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {});
//
//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       if (mounted) {
//         setState(() {
//           if (_currentIndex + 1 == images.length) {
//             _currentIndex = 0;
//           } else {
//             _currentIndex = _currentIndex + 1;
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child:AnimatedSwitcher(
//         duration: const Duration(milliseconds: 1500),
//         transitionBuilder: (Widget child, Animation<double> animation) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//         child: Image.asset(
//           images[_currentIndex],
//           key: ValueKey<int>(_currentIndex),
//           fit: BoxFit.cover,
//           gaplessPlayback: true,
//           height: double.infinity,
//           width: double.infinity,
//         ),
//       ),
//
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';

import '../../../res/app_drawables.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Timer? _timer;
  bool _isInitialLoad = true; // ✅ Track first load

  final List<String> images = [
    AppDrawables.banner,
    AppDrawables.bannerOne,
    AppDrawables.bannerTwo,
  ];

  @override
  void initState() {
    super.initState();
    _startCarousel();

    // ✅ Mark as loaded after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    });
  }

  void _startCarousel() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:AnimatedOpacity(
      duration: const Duration(milliseconds: 00),
      opacity: _isInitialLoad ? 0.0 : 1.0, // ✅ Fade in first image
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1500),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.03, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.05, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
        child:  Image.asset(
            images[_currentIndex],
            key: ValueKey<int>(_currentIndex),
            fit: BoxFit.fill,
            gaplessPlayback: true,
            height: double.infinity,
            width: double.infinity,
            filterQuality: FilterQuality.medium,
            isAntiAlias: true,
          ),
      )
      ),
    );
  }
}
