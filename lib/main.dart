import 'package:spotter/firebase_options.dart';
import 'package:spotter/splash_view.dart';
import 'package:spotter/view-model/auth_view_model.dart';
import 'package:spotter/view-model/crime_prediction_view_model.dart';
import 'package:spotter/view-model/crime_rate_view_model.dart';
import 'package:spotter/view-model/crime_type_view_model.dart';
import 'package:spotter/view-model/profile_view_model.dart';
import 'package:spotter/view-model/report_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print(message.data.toString());
  // print(message.notification!.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthViewModel()),
            ChangeNotifierProvider(create: (_) => ReportViewModel()),
            ChangeNotifierProvider(create: (_) => CrimePredictionViewModel()),
            ChangeNotifierProvider(create: (_) => CrimeTypeViewModel()),
            ChangeNotifierProvider(create: (_) => CrimeRateViewModel()),
            ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SPOTTER',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: child,
            builder: EasyLoading.init(),
          ),
        );
      },
      child: const SplashView(),
    );
  }
}
