import 'package:flutter/material.dart';
import 'package:tamkin/services/providers/Auth_Provider.dart';
import 'app/My_App.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


