import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:ielts_reading/Utills/Constants.dart';
import 'package:ielts_reading/Utills/UIUtills.dart';
import 'package:path_provider/path_provider.dart';

class AnswerScreen extends StatefulWidget{
  AnswerScreen({Key key, this.id}) : super(key: key);
  final String id;
  _AnswerScreen createState() =>_AnswerScreen();
}

class _AnswerScreen extends State<AnswerScreen> {
  bool _isLoading = true;
  PDFDocument document;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    loadDocument(widget.id);
  }
  loadDocument(String id) async {

    document = await PDFDocument.fromAsset('assets/pdf/q'+id+'.pdf');
    print(document.count);
    setState(() => _isLoading = false);
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
          children: [
            Container(
              color: Constants.main_color,
              padding: EdgeInsets.fromLTRB(cW(10), cH(15), cW(10), cH(15)),
              child: Stack(
                children: [
                  Container(
                    // margin: EdgeInsets.only(top: cH(10)),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: ImageIcon(AssetImage("assets/back.png")),
                      iconSize: cW(20),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop(this);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Answer',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            Expanded(
                child: Center(
                  child: _isLoading
                      ? Center(child: SizedBox(
                    height: cH(30),
                    width: cH(30),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ))
                      : PDFViewer(
                    document: document,
                    zoomSteps: 1,
                    //uncomment below line to preload all pages
                    lazyLoad: false,
                    // uncomment below line to scroll vertically
                    scrollDirection: Axis.vertical,
                    showNavigation: true,

                  ),
                ),
            ),
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
    );  }
}