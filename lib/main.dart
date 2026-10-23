import 'package:finoco/config/bloc_observer/simple_bloc_observer.dart';
import 'package:finoco/core/authentication_bloc/authentication_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/auth/login/bloc/login_bloc.dart';
import 'package:finoco/features/auth/login/screens/login_screen.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/devise/bloc/devise_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/export/export_bloc.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_bloc.dart';
import 'package:finoco/features/iteration/bloc/iteration_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/firebase_options.dart';
import 'package:finoco/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';

import 'features/home/bloc/home_bloc.dart';
import 'features/home/home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> accueilNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> clientNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> synchroNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> moreNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage().initStorage;
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<DossierBloc>(
          create: (context) => DossierBloc(),
        ),
        BlocProvider<ClientBloc>(
          create: (context) => ClientBloc(),
        ),
        BlocProvider<DeviseBloc>(
          create: (context) => DeviseBloc(),
        ),
        BlocProvider<ExportBloc>(
          create: (context) => ExportBloc(),
        ),
        BlocProvider<SyncBloc>(
          create: (context) => SyncBloc()..add(LoadDatabaseStats()),
        ),
        BlocProvider<IterationBloc>(
          create: (context) => IterationBloc(),
        ),
        BlocProvider<AttachementsBloc>(
          create: (context) => AttachementsBloc(),
        ),
        BlocProvider<StatsBloc>(
          create: (context) => StatsBloc()..add(LoadStats()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;

    return MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Finoco',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (mainContext) =>
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return const HomePage();
                  }
                  if (state is AuthenticationUnauthenticated) {
                    return const LoginScreen();
                  }
                  return const SplashScreen();
                },
              ),
        });
  }
}
