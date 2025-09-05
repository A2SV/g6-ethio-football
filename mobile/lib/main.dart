import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/my_clubs/presentation/bloc/my_clubs_bloc.dart';
import 'features/my_clubs/presentation/pages/my_clubs_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI container
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Clubs App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => di.sl<MyClubsBloc>(),
        child: const MyClubsPage(),
      ),
    );
  }
}
