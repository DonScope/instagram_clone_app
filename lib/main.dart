import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app/config/app_theme/cubit/theme_cubit.dart';
import 'package:instagram_clone_app/config/app_theme/cubit/theme_state.dart';
import 'package:instagram_clone_app/core/helpers/cache_helper.dart';
import 'package:instagram_clone_app/core/notification_local.dart';
import 'package:instagram_clone_app/core/web_services/api_client.dart';
import 'package:instagram_clone_app/core/web_services/auth_service.dart';
import 'package:instagram_clone_app/core/web_services/user_service.dart';
import 'package:instagram_clone_app/data/repository/auth/auth_repository.dart';
import 'package:instagram_clone_app/data/repository/user_services/user_repository.dart';
import 'package:instagram_clone_app/firebase_options.dart';
import 'package:instagram_clone_app/presentation/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone_app/presentation/auth/ui/login_screen.dart';
import 'package:instagram_clone_app/presentation/profile/cubit/story_cubit/story_cubit.dart';
import 'package:instagram_clone_app/shared_widgets/navigation_bar_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.cachIntialization();
  await DioHelper.initDioHelper();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dsdnbwhpzqxztederwjm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRzZG5id2hwenF4enRlZGVyd2ptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0Nzk4NDUsImV4cCI6MjA1NTA1NTg0NX0.sZsXLOT4rkGPbd4EuCL2OZX28CyZKMJB-dsX9lsBH3Y',
  );
  NotificationLocal.init();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "firebase",
        channelName: "firebase",
        channelDescription: "notification for firebase",
        importance: NotificationImportance.High,
        playSound: true,
        channelShowBadge: true,
        enableVibration: true,
        enableLights: true,
      )
    ],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository(AuthService())),
        ),
        BlocProvider(
          create: (context) =>
              StoryCubit(UserRepository(UserService()))..getAllStories(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 944),
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                title: 'Insta',
                theme: state.themeData,
                debugShowCheckedModeBanner: false,
                home: CacheHelper.getData(key: "uId") == null
                    ? LoginScreen()
                    : NavigationBarScreeen());
          },
        ),
      ),
    );
  }
}
