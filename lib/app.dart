import 'commons.dart';

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Health Alert',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20),
        ),
      ),

      home: HomeView(),
      routes: {
        '/contacts': (context) => ContactsView(),
        '/emergency': (context) => EmergencyAlertView(),
      },
    );
  }
}