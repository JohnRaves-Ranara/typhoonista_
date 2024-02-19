import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Typhoon.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class delete_comp extends StatefulWidget {
  const delete_comp({super.key});

  @override
  State<delete_comp> createState() => _delete_compState();
}

class _delete_compState extends State<delete_comp> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: StreamBuilder<Typhoon>(
              stream: FirestoreService2().streamOngoingTyphoon(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          // color: Colors.blue,
                          child: Image.asset(
                        'lib/assets/images/Vector (2).png',
                        height: 20,
                        color: Colors.white,
                      )),
                      Text(
                        'Delete Estimation',
                        style:
                            textStyles.lato_bold(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
                }else{
                  return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          // color: Colors.blue,
                          child: Image.asset(
                        'lib/assets/images/Vector (2).png',
                        height: 20,
                        color: Colors.black,
                      )),
                      Text(
                        'Delete Estimation',
                        style:
                            textStyles.lato_bold(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.shade700,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
                }
              }
            ),
          );
  }
}