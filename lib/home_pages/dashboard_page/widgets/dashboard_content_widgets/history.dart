import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/allDaysTable.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'package:provider/provider.dart';

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
              
              height: 55,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)) ),
              
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('HISTORY', style: textStyles.lato_black(fontSize: 15),),
                    InkWell(
                      onTap: ((){
                        context.read<page_provider>().changePage(3);
                      }),
                      child: Text('VIEW ALL DATA >', style: textStyles.lato_bold(color: Colors.blue),))
                  ],
                ),
              ),
            ),
            allDaysTable()
          ],
        ),
      ),
    );
  }
}