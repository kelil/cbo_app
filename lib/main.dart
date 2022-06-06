import 'package:cbo_app/ui/about.dart';
import 'package:cbo_app/ui/home.dart';
import 'package:cbo_app/ui/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    int _selectedIndex = 0;

static const List<Widget> _widgetOptions = <Widget>[
  Home(),
  Services(),
  About()
];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //  AppBar(
        //    centerTitle: true,
        //    backgroundColor: Colors.white,
        //    title: Row(
        //      children: [
        //         Image.asset('images/Cooperative_Bank_of_Oromia.png', height:32, fit: BoxFit.contain),
        //         const SizedBox(width: 25,height: 1),
        //         const Text('Coopay-EBirr', style: TextStyle(color: Colors.lightBlue),)
        //      ],
        //    ) 
        //  )

       appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 2,
          toolbarOpacity: 0,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesome5Brands.servicestack),
                  label: 'Discover Us',
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesome.users),
                  label: 'About Us',
                  backgroundColor: Colors.lightBlue),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.6),
            iconSize: 20,
            onTap: _onItemTapped,
            elevation: 5)
      ),
    );
  }
}




