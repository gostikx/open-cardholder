import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opencardholder/router/router.dart';
import 'package:opencardholder/services/database_service.dart';
import 'package:opencardholder/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'OpenCardHolder',
      theme: defaultAppTheme,
      routerConfig: router,
    );
  }
}
