import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/allDaysTable.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          
          borderRadius: BorderRadius.circular(26)
        ),
        child: Column(
          children: [
            Container(
              
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('HISTORY', style: textStyles.lato_black(fontSize: 15),),
                    Text('VIEW ALL TYPHOON DATA >', style: textStyles.lato_bold(color: Colors.blue),)
                  ],
                ),
              ),
              height: 55,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)) ),
            ),
            allDaysTable()
          ],
        ),
      ),
    );
  }
}