import 'package:eashtonsfishies/pages/user_pages/profile_screen.dart';
import 'package:eashtonsfishies/pop/loggedin_layout.dart';
import 'package:flutter/material.dart';//resporitory//page
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
class HomeLogScreen extends StatelessWidget {
  const HomeLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: CentredView(
        child: Column(
          children: <Widget>[
            NavigationBar(),
            
            Expanded(
              child: Row(
                children: [
                  LoggedinPageLayout(),
                ]
              ),
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
              
                // automaticallyImplyLeading: false, this is used to remove the back button
              _NavBarItem('basket'),
              SizedBox(
                width:20,
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(
                      appBar: AppBar(
                        title: Text('Profile'),
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: [
                          SizedBox(
                            width:50,
                          ),
                          IconButton(
                            icon: Icon(Icons.lock_person),
                            onPressed: () => CustomProfileScreen(),
                          ),
                          SizedBox(
                            width:50,
                          ),
                          IconButton(
                            icon: Icon(Icons.paid_rounded),
                            onPressed: () async {
                              AlertDialog(
                                title: Text('cool back'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => showInvoicesDialog,
                                    child: Text('back'),
                                  ),
                                ],
                              );
                            },

                          ),
                        ],
                      ),
                    )),
                    );
                },
              ),
              SizedBox(
                width:20,
              ),
              SignOutButton(),
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
