import 'package:flutter/material.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/screens/all_pictures_screen.dart';
import 'package:nasa_apod_app/services/media.dart' show Media;
import 'package:nasa_apod_app/services/saved_provider.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
import 'package:nasa_apod_app/widgets/details_screen_widgets/detail_page.dart';
import 'package:provider/provider.dart' show Provider;

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details-screen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController? _pageController;
  double? currentPageValue = 0.0;
  bool enablePageView = false;
  List? spaceMedias;
  late final SpaceMedia spaceMedia;
  String? comingFrom;
  int? index;
  Media? media;

  bool init = true;

  @override
  void didChangeDependencies() {
    if (init) {
      final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      enablePageView = arguments['enablePageView'] as bool;
      spaceMedia = arguments['spaceMedia'] as SpaceMedia;
      index = arguments['index'] as int?;
      comingFrom = arguments['comingFrom'] as String?;
      if (enablePageView) {
        currentPageValue = index!.toDouble();
        _pageController = PageController(
          initialPage: enablePageView ? index! : 0,
        );
        _pageController!.addListener(() {
          setState(() {
            currentPageValue = _pageController!.page;
          });
        });
      }
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController?.removeListener(() {
      setState(() {
        currentPageValue = _pageController!.page;
      });
    });
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.headline1;
    final double topPadding = MediaQuery.of(context).padding.top;
    bool pageViewWasSetup = false;

    if (_pageController != null) {
      pageViewWasSetup = _pageController!.hasClients;
    }
    if (enablePageView) {
      if (comingFrom == AllPicturesScreeen.routeName) {
        media = Provider.of<Media>(context);
      } else {
        final SavedProvider savedProvider = Provider.of<SavedProvider>(context);
        spaceMedias = savedProvider.spaceMedias;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          currentPageValue!.floor(),
        );
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: DetailsAppBar(
          scaffoldKey: _scaffoldKey,
          spaceMedia: pageViewWasSetup
              ? (media != null
                  ? currentPageValue! < media!.spaceMedias.length
                      ? media!.spaceMedias[currentPageValue!.floor()]
                      : media!.spaceMedias.last
                  : currentPageValue! < spaceMedias!.length
                      ? spaceMedias![currentPageValue!.floor()] as SpaceMedia
                      : spaceMedias!.last as SpaceMedia)
              : spaceMedia,
          comingFrom: comingFrom,
          index: currentPageValue!.floor(),
        ),
        body: BackgroundGradient(
          height: MediaQuery.of(context).size.height,
          child: enablePageView
              ? (media != null
                  ? PageView.builder(
                      itemCount: media!.spaceMedias.length + 1,
                      controller: _pageController,
                      itemBuilder: (_, i) {
                        if (i < media!.spaceMedias.length) {
                          return DetailPage(
                            spaceMedia: media!.spaceMedias[i],
                            topPadding: topPadding,
                            titleTheme: titleTheme,
                            index: i,
                          );
                        }
                        return const CenteredCircularProgressIndicator();
                      },
                      onPageChanged: (page) {
                        if (page > media!.spaceMedias.length - 3) {
                          media!.loadMore();
                        }
                      },
                    )
                  : PageView.builder(
                      itemCount: spaceMedias!.length,
                      controller: _pageController,
                      itemBuilder: (_, i) {
                        return DetailPage(
                          index: i,
                          spaceMedia: spaceMedias![i] as SpaceMedia,
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
      ),
    );
  }
}
