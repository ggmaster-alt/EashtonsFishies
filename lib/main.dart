import 'package:eashtonsfishies/firebase/authentication_respitory.dart'; //for authentication services
import 'package:eashtonsfishies/invoices/invoice_page.dart'; //page
import 'package:eashtonsfishies/pages/admin_pages/admin_page.dart'; //page
import 'package:eashtonsfishies/pages/admin_pages/user_view.dart'; //page
import 'package:eashtonsfishies/pages/user_pages/logged_in_page.dart';
import 'package:eashtonsfishies/pop/cart_provider.dart';
import 'package:eashtonsfishies/pop/login_button.dart'; //page
import 'package:eashtonsfishies/pages/user_pages/product_list_page.dart'; //page
import 'package:eashtonsfishies/pages/user_pages/basket.dart'; //page
import 'package:provider/provider.dart';//package
import 'pages/user_pages/about_page.dart'; //page
import 'package:get/get.dart'; //line 28 following coding with t
import 'package:eashtonsfishies/pages/admin_pages/inventory_page.dart'; //page
import 'package:eashtonsfishies/pages/admin_pages/invoice_view_page.dart';
import 'package:flutter/material.dart'; //resporitory
import 'package:firebase_core/firebase_core.dart'; //resporitory
import 'package:eashtonsfishies/firebase/firebase_options.dart'; // firebase options

import 'package:eashtonsfishies/pages/authentication/auth_page.dart'; //handles login
import 'package:eashtonsfishies/pop/home_page_text.dart'; // used for article widgets on the main page

const bool showDebuggedBanner = false;

void main() async {
  // start
  WidgetsFlutterBinding.ensureInitialized(); 
  // this is a asyncronous function call gives the flutter code to firebase
  await Firebase.initializeApp(// firebase call
    options: DefaultFirebaseOptions.currentPlatform, 
    // sets firebase options to see more goto: 
    // eashtonsfishies/lib/firebase/firebase_options.dart
  ).then((value) => Get.put(AuthenticationRepository())); 
  // then handles asyncronous operation(calls it together).
  // get.put is a getX controller function, 
  // sends information to: 
  // eashtonsfishies/lib/firebase/authentication_respitory.dart 
  // basically checks user info state
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), //
      child: MyApp(), //first state call
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // main build of app this is the top state in the flutter tree
        debugShowCheckedModeBanner: showDebuggedBanner,
        routes: {
          // custom control of flow in the app
          'Fish': (context) => ProductList(), // clicks both because of size.
          'About': (context) => AboutPage(),
          'basket': (context) => FishBasket(),
          'SignUp | Login': (context) => AuthGate(),
          'inventory': (context) => InventoryPage(),
          'users': (context) => UserListPage(),
          'admin': (context) => AdminHomePage(),
          'invoices': (context) => InvoicePage(),
          'userPage': (context) => HomeLogScreen(),
          'user invoices': (context) => AdminCheck(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Play fair Display',
                )),
        home: const HomeView());//pushes the main scaffold
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        body: CentredView(
          child: ScrollState(),
        ));
  }
}

class ScrollState extends StatefulWidget { 
  // stateful widgets are widgets that 
  // can change at any point throuhgout the runtime
  const ScrollState({super.key});

  @override
  ScrollableSection createState() => ScrollableSection();
}

class ScrollableSection extends State<ScrollState> {
  //final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView(
      //controller: _scrollController,
      children: <Widget>[
        NavigationBar(),
        Row(
          children: <Widget>[
            FishAdText(),
            FishPageLogin('SignUp | Login'),
          ],
        ),
        SizedBox(
          height: 100,
        ),
        Row(
          children: <Widget>[
            FishAdText(),
            FishPageLogin('SignUp | Login'),
          ],
        ),
        SizedBox(
          height: 100,
        ),
        Row(
          children: <Widget>[
            FishAdText(),
            FishPageLogin('SignUp | Login'),
          ],
        ),
        SizedBox(
          height: 100,
        ),
        Row(
          children: <Widget>[
            FishAdText(),
            FishPageLogin('SignUp | Login'),
          ],
        ),
      ],
    );
  }
}

class NavigationBar extends StatelessWidget { //navigation bar
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 150,
                child: Image.asset('images/ashtonslogosml.png'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _NavBarItem('Fish'),
                  SizedBox(
                    width: 20,
                  ),
                  _NavBarItem('About'),
                  SizedBox(
                    width: 20,
                  ),
                  _NavBarItem('SignUp | Login'),
                ],
              ),
            ]));
  }
}

class _NavBarItem extends StatelessWidget {
  // function lays out navbar push context
  final String title;
  const _NavBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, title);
      },
      child: Text(
        //can have a child in each widget, 
        //see weather or not in the documentation in the widgetbar
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class CentredView extends StatelessWidget { 
  //useful widget for the scroll bar is the formatting.
  final Widget child;
  const CentredView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 60),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}

//scrollable
