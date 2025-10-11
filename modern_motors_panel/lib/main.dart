// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:modern_motors_panel/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:modern_motors_panel/app_theme.dart';
import 'package:modern_motors_panel/model/notifications/received_notification.dart';
import 'package:modern_motors_panel/provider/chart_of_accounts_screen.dart';
import 'package:modern_motors_panel/provider/connectivity_provider.dart';
import 'package:modern_motors_panel/provider/drop_down_controller_provider.dart';
import 'package:modern_motors_panel/provider/estimation_provider.dart';
import 'package:modern_motors_panel/provider/hide_app_bar_provider.dart';
import 'package:modern_motors_panel/provider/main_page_provider.dart';
import 'package:modern_motors_panel/provider/maintenance_booking_provider.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:modern_motors_panel/provider/resource_provider.dart';
import 'package:modern_motors_panel/provider/selected_inventories_provider.dart';
import 'package:modern_motors_panel/provider/sell_order_provider.dart';
import 'package:modern_motors_panel/services/local/branch_id_sp.dart';
import 'package:modern_motors_panel/sign_in_screens/sign_in.dart';
import 'package:modern_motors_panel/widgets/check_profile.dart';
import 'package:provider/provider.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages

// late AudioHandler audioHandler;
// final shorebirdCodePush = ShorebirdUpdater();

int id = 0;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;
String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Constants.updateBookingStatus(notificationResponse.actionId!, notificationResponse.payload!);
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //final database = AppDb();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  log('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    debugPrint(jsonEncode(message.data));
    if (message.data['type'] != null && message.data['type'] == 'created') {
      showNotificationWithActions(message);
    } else {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/launcher_icon',
          ),
        ),
      );
    }
  }
}

Future<void> showNotificationWithActions(RemoteMessage message) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }
  RemoteNotification? notification = message.notification;
  dynamic data = message.data;
  List<AndroidNotificationAction>? actions = <AndroidNotificationAction>[];
  if (data['type'] == 'created') {
    if (data['providerID'] == user.uid) {
      actions.add(
        const AndroidNotificationAction(
          'providerConfirmed',
          'Accept',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        ),
      );
      actions.add(
        const AndroidNotificationAction(
          'providerRejected',
          'Reject',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        ),
      );
    } else {
      actions.add(
        const AndroidNotificationAction(
          'client_ok',
          'OK',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          cancelNotification: true,
        ),
      );
    }
  } else if (data['type'] == 'dateTimeUpdate') {
    if (data['providerID'] == user.uid) {
      actions.add(
        const AndroidNotificationAction(
          'provider_ok',
          'OK',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          cancelNotification: true,
        ),
      );
    } else {
      actions.add(
        const AndroidNotificationAction(
          'client_ok',
          'OK',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          cancelNotification: true,
        ),
      );
    }
  } else if (data['type'] == 'providerRejected' ||
      data['type'] == 'providerConfirmed' ||
      data['type'] == 'providerCompleted' ||
      data['type'] == 'providerCancelled') {
    actions.add(
      const AndroidNotificationAction(
        'client_ok',
        'OK',
        icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        cancelNotification: true,
      ),
    );
  } else if (data['type'] == 'close' ||
      data['type'] == 'clientCancelled' ||
      data['type'] == 'clientRejected') {
    actions.add(
      const AndroidNotificationAction(
        'provider_ok',
        'OK',
        icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        cancelNotification: true,
      ),
    );
  } else if (data['type'] == 'autoClose') {
    if (data['providerID'] == user.uid) {
      actions.add(
        const AndroidNotificationAction(
          'provider_ok',
          'OK',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          cancelNotification: true,
        ),
      );
    } else {
      actions.add(
        const AndroidNotificationAction(
          'client_ok',
          'OK',
          icon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
          cancelNotification: true,
        ),
      );
    }
  } else if (data['type'] == 'dateTimeUpdate') {
    if (data['providerID'] == user.uid) {
    } else {}
  }
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        actions: actions,
        /*
    actions: const <AndroidNotificationAction>[
      AndroidNotificationAction(
        urlLaunchActionId,
        'Action 1',
        icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        contextual: true,
      ),
      AndroidNotificationAction(
        'id_2',
        'Action 2',
        titleColor: Color.fromARGB(255, 255, 0, 0),
        icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
      AndroidNotificationAction(
        navigationActionId,
        'Action 3',
        icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        showsUserInterface: true,
        // By default, Android plugin will dismiss the notification when the
        // user tapped on a action (this mimics the behavior on iOS).
        cancelNotification: false,
      ),
    ],
    */
      );
  const DarwinNotificationDetails iosNotificationDetails =
      DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
      );

  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification!.title,
    notification.body,
    notificationDetails,
    payload: data['bookingID'] ?? '',
  );
}

// Future<void> _configureLocalTimeZone() async {
//   if (kIsWeb || Platform.isLinux) {
//     return;
//   }
//   tz.initializeTimeZones();
//   // String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   // tz.setLocalLocation(tz.getLocation(timeZoneName));
// }

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await BranchIdSp.initSp();
  // audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   ),
  //);
  //audioHandler.setRepeatMode(AudioServiceRepeatMode.all);

  // await RemoteConfigService().initialize();
  await EasyLocalization.ensureInitialized();
  //await Hive.initFlutter();
  //open the box
  //await Hive.openBox("localMemory");
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        // ChangeNotifierProvider<StorageProvider>(
        //   create: (_) => StorageProvider(),
        // ),
        // ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
        // ChangeNotifierProvider<TimerProvider>(create: (_) => TimerProvider()),
        // ChangeNotifierProvider<LocationProvider>(
        //   create: (_) => LocationProvider(),
        // ),
        ChangeNotifierProvider<ResourceProvider>(
          create: (_) => ResourceProvider(),
        ),
        ChangeNotifierProvider<ConnectivityProvider>(
          create: (_) => ConnectivityProvider(),
        ),

        ///ChangeNotifierProvider<UpdateProvider>(create: (_) => UpdateProvider()),
        //ChangeNotifierProvider<LoadingProvider>(
        //  create: (_) => LoadingProvider(),
        //),
        // ChangeNotifierProvider<LocalMemoryProvider>(
        //   create: (_) => LocalMemoryProvider(),
        // ),
        ChangeNotifierProvider(create: (_) => DropdownControllerProvider()),
        ChangeNotifierProvider(create: (_) => SellOrderProvider()),
        ChangeNotifierProvider(create: (_) => SelectedInventoriesProvider()),
        ChangeNotifierProvider(create: (_) => MaintenanceBookingProvider()),
        //ChangeNotifierProvider(create: (_) => ChartOfAccountsProvider()),
        ChangeNotifierProvider(create: (_) => EstimationProvider()),
        ChangeNotifierProvider(create: (_) => MmResourceProvider()),
        ChangeNotifierProvider(create: (_) => MainPageProvider()),
        ChangeNotifierProvider(create: (_) => HideAppbarProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'SA'),
          Locale('ur', "PK"),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  final Connectivity connectivity = Connectivity();
  late Future getAppFuture;
  bool isDark = false;
  @override
  void initState() {
    //context.read<UpdateProvider>().checkUpdateAvailability();
    getAppFuture = getApp();
    super.initState();
    initConnectivity();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.mobile)) {
        updateConnectionStatus(ConnectivityResult.mobile);
        return;
      }
      if (result.contains(ConnectivityResult.wifi)) {
        updateConnectionStatus(ConnectivityResult.wifi);
        return;
      }
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity()
          .checkConnectivity());
      if (connectivityResult.isEmpty) {
        return;
      }
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        result = ConnectivityResult.mobile;
      }
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        result = ConnectivityResult.wifi;
      }
    } on PlatformException catch (_) {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    context.read<ConnectivityProvider>().setConnectivity(result);
  }

  Future<FirebaseApp> getApp() async {
    FirebaseApp initialization = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
    return initialization;
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connectionStatus = context
        .watch<ConnectivityProvider>()
        .connectionStatus;
    //bool readyToInstall = context.watch<UpdateProvider>().readyToInstall;
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Global Logistics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getCurrentTheme(isDark, connectionStatus),
      home:
          // readyToInstall
          //     ? const UpdatePage(type: 'shoreBird')
          //     :
          FutureBuilder(
            future: getAppFuture,
            builder: (context, appSnapshot) {
              if (appSnapshot.connectionState == ConnectionState.done) {
                return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.active) {
                      if (userSnapshot.hasData) {
                        return const CheckProfile();
                      } else {
                        return const SignIn();
                      }
                    } else {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              } else {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
    );
  }
}

// class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
//   final item = MediaItem(
//     //id: 'assets/new_order.mp3',
//     //id: 'https://firebasestorage.googleapis.com/v0/b/globallogistics-94538.appspot.com/o/public%2Forder_alarm.mp3?alt=media&token=765e56af-d55a-4925-8141-c7f7fdd28c06',
//     id: Constants.pallet_Alarm,
//     title: "New order alert",
//   );
//   final item1 = MediaItem(
//     //id: 'assets/new_order.mp3',
//     //id: 'https://firebasestorage.googleapis.com/v0/b/globallogistics-94538.appspot.com/o/public%2Forder_alarm.mp3?alt=media&token=765e56af-d55a-4925-8141-c7f7fdd28c06',
//     id: Constants.clock_Alarm,
//     title: "New Time order alert",
//   );

//   final player = AudioPlayer();

//   AudioPlayerHandler() {
//     player.playbackEventStream.map(_transformEvent).pipe(playbackState);
//     mediaItem.add(item);
//     // mediaItem.add(item1);
//     //player.setAudioSource(AudioSource.uri(Uri.parse('asset:///${item.id}')));
//     player.setAudioSource(AudioSource.uri(Uri.parse(item.id)));
//   }

//   @override
//   Future<void> play() => player.play();
//   @override
//   Future<void> pause() => player.pause();
//   @override
//   Future<void> seek(Duration position) => player.seek(position);
//   @override
//   Future<void> stop() => player.stop();

//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.rewind,
//         if (player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.fastForward,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[player.processingState]!,
//       playing: player.playing,
//       updatePosition: player.position,
//       bufferedPosition: player.bufferedPosition,
//       speed: player.speed,
//       queueIndex: event.currentIndex,
//     );
//   }
// }
