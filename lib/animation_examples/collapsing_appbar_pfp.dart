import 'dart:math';

import 'package:flutter/material.dart';

import '../../themes/theme_constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(
                expandedHeight: size.height * 0.4,
                expandedPfpDiameter: size.height * 0.18,
                width: size.width,
                collapsedPfpDiameter: 37,
              ),
              pinned: true,
            ),
            buildImages() //some sliver like SliverList/Grid
          ],
        ),
      ),
    );
  }

  Widget buildImages() => SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ImageWidget(index: index),
          childCount: 20,
        ),
      );
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double expandedPfpDiameter;
  final double collapsedPfpDiameter;
  final double width;

  CustomSliverAppBarDelegate({
    required this.expandedHeight,
    required this.expandedPfpDiameter,
    required this.width,
    required this.collapsedPfpDiameter,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  //expanded app bar
                  Visibility(
                    visible: shrinkOffset < expandedHeight - kToolbarHeight,
                    child: Expanded(
                      child: ExpandedAppBar(
                        expandedPfpDiameter: expandedPfpDiameter,
                        shrinkOffset: shrinkOffset,
                        expandedHeight: expandedHeight,
                        width: width,
                        collapsedPfpDiameter: collapsedPfpDiameter,
                      ),
                    ),
                  ),
                  //collapsed app bar
                  Visibility(
                      visible: shrinkOffset >= expandedHeight - kToolbarHeight,
                      child: AppBar(
                        backgroundColor: kBackgroundColor,
                        flexibleSpace: SizedBox(
                          height: kToolbarHeight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Qzend",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Container(
                                  width: collapsedPfpDiameter,
                                  height: collapsedPfpDiameter,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kPrimaryColor,
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                            'https://pixy.org/src/477/4773331.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: kPrimaryColor,
                                        width: 3.0,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ExpandedAppBar extends StatelessWidget {
  const ExpandedAppBar({
    super.key,
    required this.expandedPfpDiameter,
    required this.shrinkOffset,
    required this.expandedHeight,
    required this.width,
    required this.collapsedPfpDiameter,
  });

  final double expandedPfpDiameter;
  final double collapsedPfpDiameter;
  final double shrinkOffset;
  final double expandedHeight;
  final double width;
  
  
  double get heightAbovePfp {
    return kToolbarHeight + 10 + expandedPfpDiameter;
  }

  double get heightBelowPfp {
    return expandedHeight - heightAbovePfp;
  }

  double get slope {
    return (heightAbovePfp - (kToolbarHeight / 2 + collapsedPfpDiameter / 2)) / 
    (width / 2 - (20 + collapsedPfpDiameter / 2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 3,
                top: 0,
                bottom: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Qzend",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: kBackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(
                    height: 55,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        value: false,
                        onChanged: (val) {},
                        activeThumbImage:
                            Image.asset('assets/images/dark.jpg').image,
                        inactiveThumbImage:
                            Image.asset('assets/images/light.jpg').image,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Transform.translate(
            offset: Offset(getXOffset(),-1*getYOffset(),),
            child: SizedBox(
              width: expandedPfpDiameter,
              height: expandedPfpDiameter,
              child: Align(
                alignment: Alignment.bottomCenter,
                //pfp widget
                child: Container(
                  width: getPfpSize(),
                  height: getPfpSize(),
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: const DecorationImage(
                      image: NetworkImage('https://pixy.org/src/477/4773331.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                    border: Border.all(
                      color: kBackgroundColor,
                      width: 3.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "John Doe",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            "#12es4576",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: kBackgroundColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }

  double getYOffset() {
    return isUserPfpCollapsing() ? shrinkOffset - (heightBelowPfp - 5) : 0;
  }

  double getXOffset() {
    return isUserPfpCollapsing() ? getYOffset() / slope : 0;
  }

  double getPfpSize() {
    return isUserPfpCollapsing()
        ? max(expandedPfpDiameter * (1 - getYOffset() / heightAbovePfp), collapsedPfpDiameter)
        : expandedPfpDiameter;
  }

  bool isUserPfpCollapsing() {
    return shrinkOffset >= heightBelowPfp;
  }
}

class ImageWidget extends StatelessWidget {
  final int index;

  const ImageWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 150,
        width: double.infinity,
        child: Card(
          child: Image.network(
            'https://source.unsplash.com/random?sig=$index',
            fit: BoxFit.cover,
          ),
        ),
      );
}
