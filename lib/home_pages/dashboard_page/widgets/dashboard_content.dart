import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/history.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/recent_estimation.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/recorded_typhoons.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/weather_forecast.dart';

class dashboard_content extends StatefulWidget {
  const dashboard_content({super.key});

  @override
  State<dashboard_content> createState() => _dashboard_contentState();
}

class _dashboard_contentState extends State<dashboard_content> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Container(
                child: Column(
              children: [
                recent_estimation(),
                SizedBox(
                  height: 20,
                ),
                recorded_typhoons()
              ],
            )),
          ),
          SizedBox(
            width: 15 ,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  weather_forecast(),
                  SizedBox(
                    height: 15,
                  ),
                  history()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
