import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/services/media.dart';
import 'package:nasa_apod_app/strings.dart';
import 'package:nasa_apod_app/utils.dart';
import 'package:nasa_apod_app/widgets/app_drawer.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
import 'package:nasa_apod_app/widgets/creation_aware_widget.dart';
import 'package:nasa_apod_app/widgets/image_card.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AllPicturesScreeen extends StatefulWidget {
  static const routeName = '/all-pics';

  @override
  _AllPicturesScreeenState createState() => _AllPicturesScreeenState();
}

class _AllPicturesScreeenState extends State<AllPicturesScreeen> {
  late StreamSubscription subscription;
  bool connected = true;
  final AutoScrollController _autoController = AutoScrollController();

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  void scrollToIndex(int index) {
    _autoController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Media media = Provider.of<Media>(context);
    final List<SpaceMedia> spaceMedias = media.spaceMedias;

    return Scaffold(
      drawer: const AppDrawer(prevScreen: AllPicturesScreeen.routeName),
      extendBodyBehindAppBar: true,
      body: BackgroundGradient(
        child: LiquidPullToRefresh(
          onRefresh: media.refresh,
          color: darkBlue,
          height: 150,
          child: CustomScrollView(
            controller: _autoController,
            slivers: <Widget>[
              SliverAppBar(
                title: const Text(Strings.allPicturesScreenTitle),
                floating: true,
                bottom: connected ? null : LostConnectionBar(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    if (spaceMedias.isEmpty) {
                      return SizedBox(
                        height: Utils.getHeightOfPage(context),
                        width: double.infinity,
                        child: const CenteredCircularProgressIndicator(),
                      );
                    }
                    if (index + 1 > spaceMedias.length && connected) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      );
                    } else if (index + 1 > spaceMedias.length && !connected) {
                      return CreationAwareWidget(
                        itemCreated: () {
                          if (index + 3 >= spaceMedias.length) {
                            media.loadMore();
                          }
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Cannot Load More',
                              style: whiteTextStyle,
                            ),
                          ),
                        ),
                      );
                    }
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: _autoController,
                      index: index,
                      child: CreationAwareWidget(
                        itemCreated: () {
                          if (index + 3 >= spaceMedias.length) {
                            media.loadMore();
                          }
                        },
                        child: ImageCard(
                          index: index,
                          spaceMedia: spaceMedias[index],
                          comingFrom: AllPicturesScreeen.routeName,
                          scrollToFunction: scrollToIndex,
                        ),
                      ),
                    );
                  },
                  childCount: spaceMedias.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LostConnectionBar extends StatelessWidget with PreferredSizeWidget {
  final double height = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            size: height - 5,
          ),
          const SizedBox(width: 10),
          const Text(
            'Cannot connect to internet',
            style: whiteTextStyle,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
