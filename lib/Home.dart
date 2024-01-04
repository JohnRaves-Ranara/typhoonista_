import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';
import 'home_pages/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'home_pages/settings_page/settings_page.dart';
import 'home_pages/dashboard_page/dashboard_page.dart';
import 'home_pages/estimator_page/estimator_page.dart';
import 'home_pages/history_page/history_page.dart';
import 'home_pages/dashboard_page/widgets/dashboard_content_widgets/history.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    print("INITSTATE HOME");
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD HOME");
    return Consumer<page_provider>(
      builder: (context, pageProv, child) {
        // Widget? pageToBeDisplayed;
        // switch(pageProv.page){
        //   case(1):
        //   pageToBeDisplayed = dashboard_page();
        //   break;
        //   case(2):
        //   pageToBeDisplayed = estimator_page();
        //   break;
        //   case(3):
        //   pageToBeDisplayed = history_page();
        //   break;
        //   case(4):
        //   pageToBeDisplayed = documents_page();
        //   break;
        //   case(5):
        //   pageToBeDisplayed = settings_page();
        //   break;
        //   default:
        //   print("HOME DEFAULT");
          
        // }
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: Colors.green, width: 10, style: BorderStyle.solid)
                ),
            child: Row(
              children: [
                Expanded(flex: 15, child: sidebar()),

                //todo: widget below is conditional based on sidebar page selection
                //use provider and whistle
                Expanded(flex: 85, child: estimator_page())
              ],
            ),
          ),
        );
      },
    );
  }
}
