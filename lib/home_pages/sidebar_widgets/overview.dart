import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';

class overview extends StatelessWidget {
  overview({super.key});

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
              return Ink(
                height: 50,
                child: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: ((){
                    if(index==3){
                      context.read<page_provider>().changeDocumentsPage(1);
                    }
                    context.read<page_provider>().changePage(index+1);
                  }),
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      icons[index],
                      SizedBox(
                        width: 16,
                      ),
                      labels[index]
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
