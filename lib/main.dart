import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:charamba/screens/home_page.dart';
import 'package:flutter/material.dart';

import 'db_helper/db_conn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Directory documentsDir = await getApplicationDocumentsDirectory();
  DatabaseConnection databaseConnection = DatabaseConnection();
  await databaseConnection.setDatabase();
  runApp(const MyApp());
  doWhenWindowReady(() {
    var initialSize = const Size(500, 700);
    appWindow.size = initialSize;
    appWindow.minSize = initialSize;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
