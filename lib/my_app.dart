import 'package:flutter/material.dart';

import 'config/router/app_router.dart';
import 'config/router/route_names.dart';
import 'config/themes/app_themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KelimeCep',
      theme: AppTheme.lightTheme(context),
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.home,
    );
  }
}
