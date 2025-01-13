import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:eashtonsfishies/pop/login_button.dart';//page
import 'package:eashtonsfishies/pages/product_list_page.dart';//page
import 'package:eashtonsfishies/pages/basket.dart';//page
import 'package:provider/provider.dart';
import 'about_page.dart';//page



import 'package:eashtonsfishies/tables/product_information.dart';//table

import 'package:flutter/material.dart';//resporitory
import 'package:firebase_core/firebase_core.dart';//resporitory
import 'package:eashtonsfishies/firebase/firebase_options.dart';// is in lib/firebase/firebase_options.dart


import 'package:eashtonsfishies/pages/auth_page.dart';//part of the page
import 'package:eashtonsfishies/pop/home_page_text.dart'; // part of the page

const bool showDebuggedBanner = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(create: (context) => CartProvider(),
    child: MyApp(),
    ),  
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: showDebuggedBanner,
      routes: {
        'Fish': (context) => ProductList(required, products: products),// clicks both bevcause of size.
        'About': (context) => AboutPage(),
        'basket': (context) => Basket(),
        'SignUp | Login': (context) => AuthGate(),
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
  const HomeView({super.key});

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
                FishAdText(),
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
  const NavigationBar({super.key});

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _NavBarItem('Fish'),
              SizedBox(
                width:20,
              ),
              _NavBarItem('About'),
              SizedBox(
                width:20,
              ),
              _NavBarItem('SignUp | Login'),
            ],
          ),
        ]
      )
    );
  }
}

class _NavBarItem extends StatelessWidget{
  final String title;
  const _NavBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, title);
        
      },
    
      child: Text(//can have a child in each widget, see weather or not in the documentation in the widgetbar
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class CentredView extends StatelessWidget {
  final Widget child;
  const CentredView({super.key, required this.child});

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