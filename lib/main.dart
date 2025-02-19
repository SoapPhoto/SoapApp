import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soap_app/env/env.dart';

import 'config/graphql.dart';
import 'pages/app.dart';
import 'store/index.dart';
import 'utils/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait<dynamic>({
    initHiveForFlutter(),
    StorageUtil.initialize(),
  });
  // jpush.setup(
  //   appKey: dotenv.env['SENTRY_URL']!,
  //   channel: 'theChannel',
  //   production: true,
  // );
  accountStore.initialize();
  await Future.wait<dynamic>({
    pictureCachedStore.initialize(),
    appStore.initialize(),
  });
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );
  // const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarColor: Color(0x0012254A),
  //   systemNavigationBarDividerColor: Color(0x0012254A),
  // );
  // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // await FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
  // await FlutterStatusbarManager.setColor(
  //   Colors.transparent,
  //   animated: true,
  // );
  // await FlutterStatusbarManager.setNavigationBarColor(
  //   Colors.transparent,
  //   animated: true,
  // );
  // await FlutterStatusbarManager.setTranslucent(false);
  if (!kIsWeb) {
    await SentryFlutter.init(
      (SentryFlutterOptions options) {
        options.debug = false;
        options.dsn = Env.sentryUrl;
      },
      appRunner: () {
        accountStore.initializeSentry();
        runApp(GraphQLProvider(
          client: GraphqlConfig.client,
          child: const MyApp(),
        ));
      },
    );
  } else {
    runApp(GraphQLProvider(
      client: GraphqlConfig.client,
      child: const MyApp(),
    ));
  }
}
