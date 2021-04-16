import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ielts_reading/Screen/QuestionScreen.dart';
import 'package:ielts_reading/Utills/Constants.dart';
import 'package:ielts_reading/Utills/UIUtills.dart';
import 'package:mailto/mailto.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key key}) : super(key: key);
  _HomeScreen createState() =>_HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (message) async{
        print(message);

        setState(() {
          // messageTitle = message["notification"]["title"];
          // notificationAlert = "New Notification Alert";
        });

      },
      onResume: (message) async{
        print(message);
        setState(() {
          // messageTitle = message["data"]["title"];
          // notificationAlert = "Application opened from Notification";
        });

      },
      onLaunch: (message) async{
        print(message);
      },

    );
    FacebookAudienceNetwork.init(
      testingId: '2af29697-11d4-4349-8f6f-ef4d60cd5c82', //optional
    );
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
          children: <Widget>[
            Container(
              color: Constants.main_color,
              padding: EdgeInsets.fromLTRB(cW(10), cH(16), cW(10), cH(16)),
              child: Stack(
                children: [

                  Align(
                    alignment: Alignment.center,
                    child: Text('IELTS Reading',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            SizedBox(
              height: cH(30),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child:
              InkWell(
                child:Column(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width-cW(40),height: cH(15),),

                    Text('Reading',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(10),),
                    Text('399 Reading',style: TextStyle(fontSize: 17,color: Colors.black45,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(10),),
                    Text('Part-1, Part-2, Part-3',style: TextStyle(fontSize: 17,color: Colors.black45,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(15),),
                  ],
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: QuestionScreen()));
                },
              ),
            ),
            SizedBox(
              height: cH(10),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child:
              InkWell(
                child:Column(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width-cW(40),height: cH(15),),

                    Text('Share',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(15),),

                  ],
                ),
                onTap: (){
                  FacebookInterstitialAd.loadInterstitialAd(
                    placementId: (Platform.isAndroid ? Constants.android_interstitial_id: Constants.ios_interstitial_id),
                    listener: (result, value) {
                      switch (result) {
                        case InterstitialAdResult.ERROR:
                          print("Error: $value");
                          break;
                        case InterstitialAdResult.LOADED:
                          FacebookInterstitialAd.showInterstitialAd();
                          print("Loaded: $value");
                          break;
                      }
                    },
                  );
                  Share.share('check out app\n https://example.com');
                },
              ),
            ),
            SizedBox(
              height: cH(10),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child:
              InkWell(
                child:Column(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width-cW(40),height: cH(15),),

                    Text('Rate Us',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(15),),

                  ],
                ),
                onTap: (){
                  appReview();
                },
              ),
            ),
            SizedBox(
              height: cH(10),
            ),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child:
              InkWell(
                child:Column(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width-cW(40),height: cH(15),),
                    Text('Suggestion',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                    SizedBox(height: cH(15),),

                  ],
                ),
                onTap: (){
                  launchMailto();
                },
              ),
            ),
            Expanded(child: Container()),
            FacebookBannerAd(
              bannerSize: BannerSize.STANDARD,
              keepAlive: true,
              placementId: Platform.isAndroid ? Constants.android_banner_id: Constants.ios_banner_id,
              listener: (result, value) {
                switch (result) {
                  case BannerAdResult.ERROR:
                    print("Error: $value");
                    break;
                  case BannerAdResult.LOADED:
                    print("Loaded: $value");
                    break;
                  case BannerAdResult.CLICKED:
                    print("Clicked: $value");
                    break;
                  case BannerAdResult.LOGGING_IMPRESSION:
                    print("Logging Impression: $value");
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  appReview(){
    StoreRedirect.redirect(androidAppId: Constants.android_app,
        iOSAppId: Constants.ios_app);
  }
  launchMailto() async {
    final mailtoLink = Mailto(
      to: [Constants.email_id],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: Constants.email_subject,
      body: '',
    );
    await launch('$mailtoLink');
  }
}