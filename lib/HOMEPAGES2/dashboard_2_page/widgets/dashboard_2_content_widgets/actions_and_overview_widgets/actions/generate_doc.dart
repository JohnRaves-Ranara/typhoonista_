import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/statistics_page/statistics.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class stats extends StatefulWidget {
  const stats({super.key});

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: StreamBuilder<Typhoon>(
              stream: FirestoreService2().streamOngoingTyphoon(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return InkWell(
                  onTap: ((){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => statistics()));
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            // color: Colors.red,
                            child: Image.asset('lib/assets/images/Vector (1).png',
                                height: 20)),
                        Text(
                          'Statistics',
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
                            child: Image.asset('lib/assets/images/Vector (1).png',
                                height: 20)),
                        Text(
                          'Statistics',
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
}