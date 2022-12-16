import 'package:clean_arch_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arch_tdd/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:clean_arch_tdd/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade800,
          secondary: Colors.green.shade600,
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => NumberTriviaProvider(
          getConcreteNumberTrivia: di.serviceLocator(),
          getRandomNumberTrivia: di.serviceLocator(),
          inputConverter: di.serviceLocator(),
        ),
        child: const NumberTriviaPage(),
      ),
    );
  }
}
