import 'package:eashtonsfishies/loginButton.dart';
import 'package:eashtonsfishies/pages/productListPage.dart';
import 'package:flutter/material.dart';
import 'package:eashtonsfishies/fishAdText.dart';
import '/about_page.dart';
import 'package:eashtonsfishies/Product.dart';
import 'package:eashtonsfishies/pages/basket.dart';
void main() {
  runApp(MyApp());
}
const login = true;
class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  // Sample list of products
    final List<Product> products = [
      Product(id: '1', name: 'Fish 1', image: 'assets/images/ashtonslogosml.png', price: 10.0),
      Product(id: '2', name: 'Fish 2', image: 'assets/images/ashtonslogosml.png', price: 20.0),
      Product(id: '3', name: 'Fish 3', image: 'assets/images/ashtonslogosml.png', price: 30.0),
    ];
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'Fish': (context) => ProductList(required, products: products),// clicks both bevcause of size.
        'About': (context) => AboutPage(),
        'basket': (context) => Basket(),
        
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
                width:100,
              ),
              _NavBarItem('About'),
              SizedBox(
                width:100,
              ),
              if (login == true) 
                _NavBarItem('basket')
              else 
                _NavBarItem('SignUp | Login'),
              
            ]
          )
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