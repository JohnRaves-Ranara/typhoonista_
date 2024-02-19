import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class mark_finished extends StatefulWidget {
  const mark_finished({super.key});

  @override
  State<mark_finished> createState() => _mark_finishedState();
}

class _mark_finishedState extends State<mark_finished> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: StreamBuilder<Typhoon>(
              stream: FirestoreService2().streamOngoingTyphoon(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return InkWell(
                  onTap: ((){
                    showMarkFinishedDialog();
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            // color: Colors.red,
                            child: Image.asset('lib/assets/images/markfinisehd.png',
                                height: 16)),
                        Text(
                          'Mark Finished',
                          style: textStyles.lato_bold(fontSize: 16),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
                }else{
                  return InkWell(
                  onTap: null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            // color: Colors.red,
                            child: Image.asset('lib/assets/images/markfinisehd.png',
                                height: 16)),
                        Text(
                          'Mark Finished',
                          style: textStyles.lato_bold(fontSize: 16),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
                }
              }
            ),
          );
  }

  showMarkFinishedDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(left: 15, right: 15, bottom: 30),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                  child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: "This will ",
                    style: textStyles.lato_regular(
                        fontSize: 20, color: Colors.black),
                    children: [
                      TextSpan(
                          text: "mark this typhoon as 'Finished'. ",
                          style: textStyles.lato_regular(
                              color: Color(0xffAD0000))),
                      TextSpan(
                          text: "Would you like to continue? ",
                          style: textStyles.lato_regular(color: Colors.black)),
                      TextSpan(
                          text:
                              "(Please note that this action is irreversible and will remove this typhoon from the ongoing typhoon estimation)",
                          style:
                              textStyles.lato_regular(color: Color(0xffAD0000)))
                    ]),
              )),
            ),
            actions: [
              ButtonBar(
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: Container(
                      
                      height: 60,
                      width: 185,
                      color: Color(0xff00109F),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (() async {
                      await FirestoreService2()
                          .markTyphoonAsFinished();
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: 60,
                      width: 185,
                      color: Color(0xffAD0000),
                      child: Center(
                        child: Text(
                          "Mark Finished",
                          style: textStyles.lato_regular(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget fetchingPrediction(){
    return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  const SpinKitSpinningLines(
                      lineWidth: 4, size: 150, color: Colors.blue),
                  SizedBox(height: 60),
                  Text(
                    'Estimating.',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
                  ),
                  Text(
                    'This may take a while...',
                    style: textStyles.lato_bold(
                        fontSize: 22, color: Colors.black.withOpacity(0.4)),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/typhoonista_logo.png',
                          height: 22,
                          color: Color(0xff0090D9).withOpacity(0.3),
                        ),
                        SizedBox(width: 5),
                        Text('TYPHOONISTA',
                            style: textStyles.lato_bold(
                                fontSize: 14,
                                color: Color(0xff0090D9).withOpacity(0.3)))
                      ]),
                  SizedBox(
                    height: 30,
                  ),
                ],
    );
  }

}