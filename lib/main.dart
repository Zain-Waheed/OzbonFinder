import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/config/ps_theme_data.dart';
import 'package:psxmpc/testfile.dart';
import 'package:psxmpc/ui/custom_ui/app_loading/view/app_loading_view.dart';
import 'package:psxmpc/ui/vendor_ui/item/promote/view/pay_stack_view.dart';
import 'package:psxmpc/ui/vendor_ui/location/view/location_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_manager/theme_manager.dart';
import 'PaymentMethods/stripe/stripe_for_subscription.dart';
import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'config/route/router.dart' as router;
import 'core/vendor/api/ps_api_service.dart';
import 'core/vendor/db/common/ps_shared_preferences.dart';
import 'core/vendor/provider/language/app_localization_provider.dart';
import 'core/vendor/provider/promotion/item_promotion_provider.dart';
import 'core/vendor/provider/ps_provider_dependencies.dart';
import 'core/vendor/provider/user/user_provider.dart';
import 'core/vendor/repository/item_paid_history_repository.dart';
import 'core/vendor/utils/utils.dart';
import 'core/vendor/viewobject/common/language.dart';
import 'core/vendor/viewobject/product.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalization.instance.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', '');
    await prefs.setString('codeL', '');
  }

  try {
    await Firebase.initializeApp(
      //name: 'psx-multipurpose-classified-app',
      options: Platform.isIOS
          ? const FirebaseOptions(
              appId: PsConfig.iosGoogleAppId,
              messagingSenderId: PsConfig.iosGcmSenderId,
              databaseURL: PsConfig.iosDatabaseUrl,
              projectId: PsConfig.iosProjectId,
              apiKey: PsConfig.iosApiKey)
          : const FirebaseOptions(
              appId: PsConfig.androidGoogleAppId,
              apiKey: PsConfig.androidApiKey,
              projectId: PsConfig.androidProjectId,
              messagingSenderId: PsConfig.androidGcmSenderId,
              databaseURL: PsConfig.androidDatabaseUrl,
            ),
    );
    // AppCheck
    await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity
  );
  } catch (e) {
    Utils.psPrint(e.toString());
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // FirebaseMessaging.onBackgroundMessage(Utils.myBackgroundMessageHandler);

  // NativeAdmob(adUnitID: Utils.getAdAppId());

  MobileAds.instance.initialize();
  // WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  try {
    WidgetsFlutterBinding.ensureInitialized();
    Utils.cameras = await availableCameras();
    print(Utils.cameras);
  } on CameraException catch (e) {
    Utils.psPrint(e.toString());
  }

  PsConfig.showLog = true;
  runApp(PSApp());
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode!, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  Completer<ThemeData>? themeDataCompleter;
  PsSharedPreferences? psSharedPreferences;
  //==========================================================
  late final Product product;
  late final String? amount;
  late final String? howManyDay;
  late final String paymentMethod;
  late final String? stripePublishableKey;
  late final String? startDate;
  late final String startTimeStamp;
  late final ItemPromotionProvider itemPaidHistoryProvider;
  late final UserProvider userProvider;
  late final String? payStackKey;
  //==========================================================

  @override
  void initState() {
    super.initState();
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode!, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
   // PsColors.loadColor(context);
    print('*** ${Utils.convertColorToString(PsColors.primary500)}');
    // Utils.psPrint(EasyLocalization.of(context)!.locale.languageCode);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<AppLocalization>(
              create: (BuildContext context) {
            return AppLocalization.instance;
          }),
          ...providers,
        ],
        child: ThemeManager(
            defaultBrightnessPreference: BrightnessPreference.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Panacea-Soft',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales:
                    context.watch<AppLocalization>().supportedLocales,
                locale: context.watch<AppLocalization>().currentLocale,
                // home:ClickLimitScreen(),
                // home:StripeForSubscriptionView(),
                // home:PayStackView(
                //   product: Product(),
                //   amount: '',
                //   howManyDay: '',
                //   paymentMethod: '',
                //   stripePublishableKey: '',
                //   startDate: '',
                //   startTimeStamp: '',
                //   itemPaidHistoryProvider: ItemPromotionProvider(
                //       itemPaidHistoryRepository: ItemPaidHistoryRepository(psApiService: PsApiService()),
                //   ),
                //   userProvider: UserProvider(repo: null, psValueHolder: null),
                //   payStackKey: '',
                // ),
                // home:PayStackForSubscriptionView(),
              );
            }));
  }
}
