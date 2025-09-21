import 'package:flutter/material.dart';
import 'package:handwriting_ui/features/parser/screens/presentation.dart';
import './features/firebase/screens/authgate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData.light(),
      home: AuthGate(), // central scaffold with navbar
    );
  }
}


class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ParserScreen(),
    const ParserScreen()
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Parser'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Parser'),
        ],
      ),
    );
  }
}
