import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class overview extends StatefulWidget {
  overview({super.key});

  @override
  State<overview> createState() => _overviewState();
}

class _overviewState extends State<overview> {
  List<Widget> icons = [
    Image.asset(
      'lib/assets/images/dashboard.png',
      height: 22,
      width: 22,
    ),
    Image.asset(
      'lib/assets/images/estimator.png',
      height: 22,
      width: 22,
    ),
    Image.asset(
      'lib/assets/images/history.png',
      height: 22,
      width: 22,
    ),
    // Image.asset(
    //   'lib/assets/images/typhoons.png',
    //   height: 22,
    //   width: 22,
    // ),
    Image.asset(
      'lib/assets/images/documents.png',
      height: 22,
      width: 22,
    ),
  ];

  List<Widget> labels = [
    Text(
      'Dashboard',
      style: textStyles.lato_bold(color: Colors.black, fontSize: 18),
    ),
    Text(
      'Estimator',
      style: textStyles.lato_bold(color: Colors.black, fontSize: 18),
    ),
    Text(
      'History',
      style: textStyles.lato_bold(color: Colors.black, fontSize: 18),
    ),
    // Text(
    //   'Typhoons',
    //   style: textStyles.lato_bold(color: Colors.black, fontSize: 18),
    // ),
    Text(
      'Documents',
      style: textStyles.lato_bold(color: Colors.black, fontSize: 18),
    )
  ];

  List<Widget> idk = [
    Container(),
    Tooltip(
      height: 18,
      message:
          "You can only add another typhoon\nonce the ongoing typhoon is Finished.",
      textAlign: TextAlign.center,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      // height: 300,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "OVERVIEW",
              style: textStyles.lato_regular(
                  color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: icons.length,
            itemBuilder: (context, index) {
              if (index == 1) {
                return StreamBuilder<bool>(
                    stream: FirestoreService().isThereOngoingTyphoon(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(color: Colors.blue, lineWidth: 3.5, size: 30,),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("ERROR", style: textStyles.lato_bold(color: Colors.red),));
                      } else {
                        bool hasOngoingTyphoon = snapshot.data ?? false;

                        if (hasOngoingTyphoon) {
                          return Ink(
                            height: 50,
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Image.asset(
                                          'lib/assets/images/estimator.png',
                                          height: 22,
                                          width: 22,
                                          color: Colors.grey.shade400,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'Estimator',
                                          style: textStyles.lato_bold(
                                              color: Colors.grey.shade400,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: const Row(
                                      children: [
                                        Tooltip(
                                          message:
                                              "You can only add another typhoon once the\nongoing typhoon is marked as Finished.",
                                          textAlign: TextAlign.center,
                                          child: Icon(
                                            Icons.info,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Ink(
                            height: 50,
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              onTap: (() {
                                context
                                    .read<page_provider>()
                                    .changePage(index + 1);
                              }),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  icons[index],
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    'Estimator',
                                    style: textStyles.lato_bold(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    });
              } else {
                return Ink(
                  height: 50,
                  child: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: (() {
                      if (index == 3) {
                        context.read<page_provider>().changeDocumentsPage(1);
                      }
                      context.read<page_provider>().changePage(index + 1);
                    }),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        icons[index],
                        SizedBox(
                          width: 16,
                        ),
                        labels[index]
                      ],
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
