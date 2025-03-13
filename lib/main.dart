import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contact_provider.dart';
import 'ui/contacts_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: MaterialApp(
        title: 'Contact Scanner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ContactsListScreen(),
      ),
    );
  }
}
