import 'package:cchelper/core/dio_client.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_bloc.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/bloc/week_menu_event.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/pages/account_settings_page.dart';
import 'package:cchelper/features/weekly_meal_planner/presentation/pages/weekly_meal_planner_page.dart';
import 'package:cchelper/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  locator<DioClient>().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeekMenuBloc>(
          create: (_) => locator<WeekMenuBloc>()..add(const LoadWeekMenuEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'CcHelper',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WeeklyMealPlannerPage(showAppBar: true),
    AccountSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Weekly Meal',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Account Settings',
          ),
        ],
      ),
    );
  }
}