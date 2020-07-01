import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../models/space_media.dart';
import '../services/media.dart' show Media;
import '../widgets/background_gradient.dart';
import '../widgets/details_screen_widgets/detail_page.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details-screen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController _pageController;
  bool enablePageView = false;
  SpaceMedia spaceMedia;
  int index;
  Media media;
  DateTime date;

  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      final Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      enablePageView = arguments['enablePageView'] as bool;
      spaceMedia = arguments['spaceMedia'] as SpaceMedia;
      index = arguments['index'] as int;
      if (enablePageView) {
        _pageController = PageController(
          initialPage: enablePageView ? index : 0,
          keepPage: true,
        );
      }
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.headline1;
    final double topPadding = MediaQuery.of(context).padding.top;
    if (enablePageView) {
      media = Provider.of<Media>(context);
    }
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: DetailsAppBar(
        scaffoldKey: _scaffoldKey,
        spaceMedia: _pageController.hasClients ? media.spaceMedias[_pageController.page.round()] : spaceMedia,
      ),
      body: BackgroundGradient(
        height: MediaQuery.of(context).size.height,
        child: enablePageView
            ? PageView.builder(
                itemCount: media.spaceMedias.length + 1,
                controller: _pageController,
                itemBuilder: (ctx, i) {
                  if (i < media.spaceMedias.length) {
                    return DetailPage(
                      spaceMedia: media.spaceMedias[i],
                      topPadding: topPadding,
                      titleTheme: titleTheme,
                      index: i,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                onPageChanged: (page) {
                  if (page > media.spaceMedias.length - 3) {
                    media.loadMore();
                  }
                },
              )
            : DetailPage(
                spaceMedia: spaceMedia,
                topPadding: topPadding,
                titleTheme: titleTheme,
                index: 0,
              ),
      ),
    );
  }
}
