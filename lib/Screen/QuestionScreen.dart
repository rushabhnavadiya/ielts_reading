

import 'dart:io';

import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:ielts_reading/Model/QuetionModel.dart';
import 'package:ielts_reading/Utills/Constants.dart';
import 'package:ielts_reading/Utills/UIUtills.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import 'AnswerScreen.dart';

class QuestionScreen extends StatefulWidget{
  QuestionScreen({Key key}) : super(key: key);
  _QuestionScreen createState() =>_QuestionScreen();
}

class _QuestionScreen extends State<QuestionScreen> {
  // QuestionModel questionModel = QuestionModel();
  List<Questions> questionList = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // extractZipFile();
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
    loadQuestionData().then((value) {
      // questionModel = value;
      setState(() {
        questionList = value.data;
      });

      print(value.data.length);
    });
  }
  /*extractZipFile() async {
    // final zipFile = File("assets/AC.zip");
    File file;
    try {
      var dir = await getApplicationDocumentsDirectory();
      file = File("${dir.path}/AC.zip");
      var data = await rootBundle.load("assets/AC.zip");
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    Directory documentDirectory;
    if (Platform.isAndroid) {
      documentDirectory = await getExternalStorageDirectory();
    }
    else{
      documentDirectory=await getApplicationDocumentsDirectory();
    }
    String documentPath = documentDirectory.path;
    print(documentPath+"/PDFs");
    final destinationDir = Directory(documentPath+"/PDFs");

    try {
      await ZipFile.extractToDirectory(
          zipFile: file,
          destinationDir: destinationDir,
          onExtracting: (zipEntry, progress) {
            print('progress: ${progress.toStringAsFixed(1)}%');
            print('name: ${zipEntry.name}');
            print('isDirectory: ${zipEntry.isDirectory}');
            print(
                'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
            print('uncompressedSize: ${zipEntry.uncompressedSize}');
            print('compressedSize: ${zipEntry.compressedSize}');
            print('compressionMethod: ${zipEntry.compressionMethod}');
            print('crc: ${zipEntry.crc}');
            return ExtractOperation.extract;
          });
    } catch (e) {
      print(e);
    }
  }*/
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
                      iconSize: 20,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop(this);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Questions',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
                  )
                ],
              ),
            ),
            Expanded(
                child: questionList.length != 0?
                Container(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: cH(20)),
                      itemCount: questionList.length,
                      itemBuilder: (BuildContext context,int index){
                        return Card(
                          margin: EdgeInsets.only(left: cW(15),right: cW(15),bottom: cH(10)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(cW(15), cH(20), cW(15), cH(20)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Question '+questionList[index].id.toString(),style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                                        SizedBox(height: cH(7),),
                                        Text(questionList[index].question??'-',style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),

                                        // Expanded(
                                        //   child: Align(
                                        //     alignment: Alignment.centerRight,
                                        //     child: Text(questionList[index].question,style: TextStyle(fontSize: 10,color: Colors.black54,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                                        //   ),
                                        // )

                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.navigate_next),
                                    iconSize: cW(25),
                                    color: Colors.black,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.rightToLeft,
                                              child: AnswerScreen(id:questionList[index].id)));

                                    },
                                  ),
                                ],
                              ),

                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: AnswerScreen(id:questionList[index].id)));

                            },
                          ),
                        );
                      }
                  ),
                ):Center(
                  child: SizedBox(
                    height: cH(30),
                    width: cH(30),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                  ),
                )
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
    );
  }


}