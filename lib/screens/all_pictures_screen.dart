import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../models/space_media.dart';
import '../services/media.dart';
import '../strings.dart';
import '../utils.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/creation_aware_widget.dart';
import '../widgets/image_card.dart';

class AllPicturesScreeen extends StatefulWidget {
  static const routeName = '/all-pics';

  final Function showNotification;

  const AllPicturesScreeen({Key key, this.showNotification}) : super(key: key);

  @override
  _AllPicturesScreeenState createState() => _AllPicturesScreeenState();
}

class _AllPicturesScreeenState extends State<AllPicturesScreeen> {
  StreamSubscription subscription;
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
      preferPosition: AutoScrollPosition.begin,
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
          onRefresh: media != null ? media.refresh : () async {},
          color: darkBlue,
          height: 150,
          child: CustomScrollView(
            controller: _autoController,
            slivers: <Widget>[
              SliverAppBar(
                title: Text(Strings.allPicturesScreenTitle),
                floating: true,
                bottom: connected ? null : LostConnectionBar(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    if (spaceMedias.isEmpty) {
                      return Container(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.showNotification();
        },
        child: Icon(Icons.alarm),
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
