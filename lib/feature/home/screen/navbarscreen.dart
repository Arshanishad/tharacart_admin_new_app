import 'package:flutter/material.dart';
import 'package:tharacart_admin_new_app/manage_widget.dart';
import 'home_page_widget.dart';

class NavBarScreen extends StatefulWidget {

  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {

  int pageIndex=0;
  onPageChanged(int page){
    setState(() {
      pageIndex=page;

    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePageWidget(),
    ManageWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:  const Color(0xFF1E2674),
          selectedItemColor:const Color(0xFF498826),
          unselectedItemColor: const Color(0x8A000000),
          onTap: onPageChanged,
          currentIndex: pageIndex,
          type:BottomNavigationBarType.fixed ,
          unselectedFontSize: 14,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items:  const [
            BottomNavigationBarItem(icon:Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon:Icon(Icons.upload),label: 'Upload'),
          ],
        ),
        body:Center(
          child: _widgetOptions.elementAt(pageIndex),
        ),
      ),
    );
  }
}