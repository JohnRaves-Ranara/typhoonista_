import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/barChart.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class recorded_typhoons extends StatefulWidget {
  const recorded_typhoons({super.key});

  @override
  State<recorded_typhoons> createState() => _recorded_typhoonsState();
}

class _recorded_typhoonsState extends State<recorded_typhoons> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 45,
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(26),
              color: Colors.white
            ),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15),
              // color: Colors.purple,
              child: Row(
                children: [
                  Expanded(
                    flex: 85,
                    child: Text(
                      "RECORDED TYPHOONS",
                      style:
                          textStyles.lato_bold(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("2023", style: textStyles.lato_regular(fontSize: 14),),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              // color: Colors.yellow,
              height: 30,
            ),
            Expanded(child: Container(
              // color: Colors.blue,
              child: barChart())),
          ],
        )));
  }
}
