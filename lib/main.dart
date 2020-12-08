import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:token_app/pages/home.dart';
import 'package:token_app/providers/preferences_provider.dart';

import 'auth/SignIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (preferences) => PreferencesProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, preferences, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: preferences.isLoggedIn ? HomePage() : SignIn(),
          );
        },
      ),
    );
  }
}
