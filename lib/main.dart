import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ielts_reading/Screen/HomeScreen.dart';
import 'package:ielts_reading/Utills/Constants.dart';

import 'Screen/SplashScreen.dart';
import 'Utills/UIUtills.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blue
    ));
  }
  @override
  Widget build(BuildContext context) {
    UIUtills().updateScreenDimension(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);

    return Scaffold(

      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar( // Here we create one to set status bar color
            backgroundColor: Constants.main_color, // Set any color of status bar you want; or it defaults to your theme's primary color
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Constants.main_color,
              padding: EdgeInsets.fromLTRB(cW(10), cH(15), cW(10), cH(15)),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: cH(5)),
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: AssetImage("assets/back.png"),
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Settings',style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
