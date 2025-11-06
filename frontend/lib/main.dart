import 'package:flutter/material.dart';
import 'app_router.dart';
import 'theme.dart';


void main() {
WidgetsFlutterBinding.ensureInitialized();
runApp(const QuestifyApp());
}


class QuestifyApp extends StatelessWidget {
const QuestifyApp({super.key});


@override
Widget build(BuildContext context) {
final router = buildRouter();


return MaterialApp.router(
title: 'Questify',
theme: appLightTheme,
darkTheme: appDarkTheme,
routerConfig: router,
);
}
}