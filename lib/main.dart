import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:story_app/config/routers/router_delegate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    debugPrint("GRANTED PERMISSION NOTIF");
  } else if (status.isDenied) {
    debugPrint("DENIED PERMISSION NOTIF");
  } else if (status.isPermanentlyDenied) {
    debugPrint("SET MANUALLY PERMISSION NOTIF");
    openAppSettings();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    myRouterDelegate = MyRouterDelegate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Router(
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
