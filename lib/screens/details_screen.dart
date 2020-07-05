import 'package:flutter/material.dart';
import 'package:nasa_apod_app/screens/all_pictures_screen.dart';
import 'package:nasa_apod_app/services/saved_provider.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
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
  List spaceMedias;
  SpaceMedia spaceMedia;
  String comingFrom;
  int index;
  Media media;

  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      final Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      enablePageView = arguments['enablePageView'] as bool;
      spaceMedia = arguments['spaceMedia'] as SpaceMedia;
      index = arguments['index'] as int;
      comingFrom = arguments['comingFrom'] as String;
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
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.headline1;
    final double topPadding = MediaQuery.of(context).padding.top;
    bool pageViewSetup = false;
    if (_pageController != null) {
      pageViewSetup = _pageController.hasClients;
    }
    if (enablePageView) {
      if (comingFrom == AllPicturesScreeen.routeName) {
        media = Provider.of<Media>(context);
      } else {
        final SavedProvider savedProvider = Provider.of<SavedProvider>(context);
        spaceMedias = savedProvider.spaceMedias;
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: DetailsAppBar(
        scaffoldKey: _scaffoldKey,
        spaceMedia: pageViewSetup
            ? (media != null
                ? media.spaceMedias[_pageController.page.round()]
                : spaceMedias[_pageController.page.round()] as SpaceMedia)
            : spaceMedia,
        comingFrom: comingFrom,
      ),
      body: BackgroundGradient(
        height: MediaQuery.of(context).size.height,
        child: enablePageView
            ? (media != null
                ? PageView.builder(
                    itemCount: media.spaceMedias.length + 1,
                    controller: _pageController,
                    itemBuilder: (_, i) {
                      if (i < media.spaceMedias.length) {
                        return DetailPage(
                          spaceMedia: media.spaceMedias[i],
                          topPadding: topPadding,
                          titleTheme: titleTheme,
                          index: i,
                        );
                      }
                      return const CenteredCircularProgressIndicator();
                    },
                    onPageChanged: (page) {
                      if (page > media.spaceMedias.length - 3) {
                        media.loadMore();
                      }
                    },
                  )
                : PageView.builder(
                    itemCount: spaceMedias.length,
                    controller: _pageController,
                    itemBuilder: (_, i) {
                      return DetailPage(
                        index: i,
                        spaceMedia: spaceMedias[i] as SpaceMedia,
                        titleTheme: titleTheme,
                        topPadding: topPadding,
                      );
                    },
                  ))
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
