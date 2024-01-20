import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/entities/Typhoon.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/home_pages/documents_page/typhoon_live_summary_page.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'typhoonDocsList.dart';

class documents_page extends StatefulWidget {
  const documents_page({super.key});

  @override
  State<documents_page> createState() => _documents_pageState();
}

class _documents_pageState extends State<documents_page> {
  bool underlined = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<page_provider>(
      builder: (context, prov, child) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.only(right: 50, left: 50, bottom: (prov.documentsPage==1) ? 70 : 40, top: 70),
            child: Column(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (prov.documentsPage == 1)
                          ? Text(
                              "Documents",
                              style: textStyles.lato_black(fontSize: 32),
                            )
                          : Row(
                              children: [
                                InkWell(
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onTap: (() {
                                      prov.changeDocumentsPage(1);
                                      setState(() {
                                        underlined = false;
                                      });
                                    }),
                                    onHover: ((bool isHovered) {
                                      setState(() {
                                        if (isHovered) {
                                          underlined = true;
                                        } else {
                                          underlined = false;
                                        }
                                      });
                                    }),
                                    child: Text(
                                      "Documents",
                                      style: textStyles.lato_black(
                                          fontSize: 32, underlined: underlined),
                                    )),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.arrow_right_sharp,
                                  size: 40,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Typhoon ${prov.selectedTyphoon!.typhoonName}",
                                  style: textStyles.lato_black(fontSize: 32),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      (prov.documentsPage == 1)
                          ? Text(
                              "The impact of the industrial revolution has began to uprise in terms of the rice and skermberlu it ornare accumsan. Justo vulputate in pretium integer vulputate vitae proin congue etiam. Sollicitudin egestas est in ultrices molestie lacus iaculis risus. Velit habitasse felis auctor at.",
                              style: textStyles.lato_light(fontSize: 18),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: (prov.documentsPage == 1)
                      ? typhoonDocsList()
                      : typhoon_live_summary_page(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
