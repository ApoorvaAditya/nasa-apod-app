import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' show Response, get;
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/models/space_media.dart';
import 'package:nasa_apod_app/screens/all_pictures_screen.dart';
import 'package:nasa_apod_app/services/get_apod.dart';
import 'package:nasa_apod_app/services/saved_provider.dart';
import 'package:nasa_apod_app/services/settings_provider.dart';
import 'package:nasa_apod_app/utils.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> initializeApp() async {
    BackgroundFetch.registerHeadlessTask(backgroundTask);
    await initializePrefsAndHive();
    await intializeNotifications();
    await initPlatformState();
  }

  Future<void> initializePrefsAndHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SpaceMediaAdapter());
    await Hive.openBox(SavedProvider.savedBoxName);
    await Hive.openBox(SettingsProvider.settingsBoxName);
  }

  Future<void> intializeNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings('notif_icon');
    const iosInitializationSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  Future<void> onSelectNotification(NotificationResponse notificationResponse) async {
    Navigator.of(context).pushReplacementNamed(AllPicturesScreeen.routeName);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    BigPictureStyleInformation? bigPictureStyleInformation,
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Astronomy Picture of the Day',
      'Daily Astronomy Picture Notification',
      channelDescription: 'Notification for whenever a new image is available',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
        ), (String taskId) async {
      await backgroundTask();
      BackgroundFetch.finish(taskId);
    });
  }

  Future<void> backgroundTask() async {
    try {
      // Get the saved post date
      final SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
      // If notifications enabled
      if (settings.getDailyNotifications()) {
        // Get the latest post date
        final DateTime? currentDate = await Utils.getLatesetPostDate;
        if (currentDate != null) {
          // Check if there is a new post
          if (currentDate.isAfter(settings.getLatestDate())) {
            // If new post, save it as latest date
            settings.setLatestDate(value: currentDate);

            final SpaceMedia? spaceMedia = await getAPOD(date: currentDate);
            if (spaceMedia != null) {
              final Response response = await get(Uri.parse(spaceMedia.url));
              final Directory documentDirectory = await getApplicationDocumentsDirectory();
              final File file = File(join(documentDirectory.path, 'daily.png'));
              await file.writeAsBytes(response.bodyBytes);
              final FilePathAndroidBitmap fileBitmap = FilePathAndroidBitmap(file.path);

              showNotification(
                title: 'New Image Available',
                body: spaceMedia.title,
                bigPictureStyleInformation: BigPictureStyleInformation(
                  fileBitmap,
                  largeIcon: fileBitmap,
                  hideExpandedLargeIcon: true,
                  contentTitle: spaceMedia.title,
                  summaryText: parseFragment(spaceMedia.description).text,
                ),
              );
            }
          }
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(AllPicturesScreeen.routeName);
          });
        }
        return Scaffold(
          body: BackgroundGradient(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CenteredCircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading',
                  style: whiteTextStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
