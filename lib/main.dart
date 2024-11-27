import 'package:eashtonsfishies/loginButton.dart';
import 'package:eashtonsfishies/fish_stock.dart';
import 'package:flutter/material.dart';
import 'package:eashtonsfishies/fishAdText.dart';
import 'about_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'Fish': (context) => FishStock(),// clicks both bevcause of size.
        'About': (context) => AboutPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Play fair Display',
        )),
      home: const HomeView());
  }
}


class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: CentredView(
        child: Column(
          children: <Widget>[
            NavigationBar(),
            Expanded(
              child: Row(children: [
                fishAdText(),
                Expanded(
                  child: Center(
                    child: FishPageLogin('SignUp | Login')))
              ]),
            ),
          ],
        ),
      )
    );
  }
}

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
          height:80,
          width:150,
          child:Image.asset('images/ashtonslogosml.png'),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _NavBarItem('Fish'),
              SizedBox(
                width:100,
                
              ),
                _NavBarItem('About')
            ]
          )
        ]
      )
    );
  }
}

class _NavBarItem extends StatelessWidget{
  final String title;
  const _NavBarItem(this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, title);
      },
    
      child: new Text(//can have a child in each widget, see weather or not in the documentation in the widgetbar
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class CentredView extends StatelessWidget {
  final Widget child;
  const CentredView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 60),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child:child,
        ),
    );
  }
}

//scrollable