import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:atomize/controllers/app_state_controller.dart';
import 'package:atomize/view/habits/habits_screen.dart';
import 'package:atomize/models/day_model.dart';
import 'package:atomize/models/habit_model.dart';
import 'package:atomize/controllers/habit_controller.dart';
import 'package:atomize/view/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateController()..load()),
        ChangeNotifierProvider(create: (_) => HabitController()..init()),
      ],
      child: ResponsiveSizer(
        builder: (_, __, ___) => const App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateController>();
    final habitController = Provider.of<HabitController>(context);

    if (!appState.initialized || !habitController.isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(appState.primaryColor),
      darkTheme: AppTheme.dark(appState.primaryColor),
      themeMode: appState.themeMode,
      locale: appState.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('hy'),
      ],
      home: const HabitsScreen(),
    );
  }
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(DayModelAdapter());
  Hive.registerAdapter(DayStateAdapter());
}
